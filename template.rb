require "bundler"
require "json"

RAILS_REQUIREMENT = "~> 6.0.0".freeze
TEMPLATE_REPO = "https://gitlab.com/yi.zeng/rails-api-templates.git".freeze
BRANCH = 'main'.freeze

def apply_template!
  assert_minimum_rails_version
  assert_valid_options
  assert_postgresql
  add_template_repository_to_source_path

  template "Gemfile.tt", force: true

  template "LICENSE.tt", force: true
  template "README.md.tt", force: true
  remove_file "README.rdoc"

  copy_file "env.development", ".env.development", force: true
  copy_file "env.production", ".env.production", force: true
  copy_file "env.test", ".env.test", force: true
  copy_file "gitignore", ".gitignore", force: true
  template "ruby-version.tt", ".ruby-version", force: true

  copy_file "Procfile"
  copy_file "Procfile.local"
  copy_file "Procfile.workers"

  apply "Rakefile.rb"
  apply "config.ru.rb"
  apply "app/template.rb"
  apply "bin/template.rb"
  apply "config/template.rb"
  apply "lib/template.rb"

  git :init unless preexisting_git_repo?
  empty_directory ".git/safe"

  run_with_clean_bundler_env "bin/setup"
  create_initial_migration
  generate_spring_binstubs

  binstubs = %w[annotate bundler rubocop]
  run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')} --force"

  run_with_clean_bundler_env  "bin/rails generate rspec:install"
  apply "spec/template.rb"

  template "overcommit.yml.tt", ".overcommit.yml"
  template "rubocop.yml.tt", ".rubocop.yml"

  run_with_clean_bundler_env "overcommit --install"

  run_rubocop_autocorrections

  unless any_local_git_commits?
    git add: "-A ."
    git commit: "-n -m 'Create Project'  -m 'Using Template from #{TEMPLATE_REPO}. Branch: #{BRANCH}.'"
    if git_repo_specified?
      git remote: "add origin #{git_repo_url.shellescape}"
      git push: "-u origin --all"
    end
  end
end

require "fileutils"
require "shellwords"

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("rails-api-templates-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "--single-branch",
      "--branch",
      BRANCH,
      TEMPLATE_REPO,
      tempdir
    ].map(&:shellescape).join(" ")

    Dir.chdir(tempdir) { git checkout: BRANCH }
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

# Bail out if user has passed in contradictory generator options.
def assert_valid_options
  valid_options = {
    skip_gemfile: false,
    skip_bundle: false,
    skip_git: false,
    skip_test: true,
    edge: false
  }
  valid_options.each do |key, expected|
    next unless options.key?(key)
    actual = options[key]
    unless actual == expected
      fail Rails::Generators::Error, "Unsupported option: #{key}=#{actual}"
    end
  end
end

def assert_postgresql
  return if IO.read("Gemfile") =~ /^\s*gem ['"]pg['"]/
  fail Rails::Generators::Error,
       "This template requires PostgreSQL, "\
       "but the pg gem isn’t present in your Gemfile."
end

def git_repo_url
  @git_repo_url ||=
    ask_with_default("What is the git remote URL for this project?", :blue, "skip")
end

def production_hostname
  @production_hostname ||=
    ask_with_default("Production hostname?", :blue, "example.com")
end

def gemfile_requirement(name)
  @original_gemfile ||= IO.read("Gemfile")
  req = @original_gemfile[/gem\s+['"]#{name}['"]\s*(,[><~= \t\d\.\w'"]*)?.*$/, 1]
  req && req.gsub("'", %(")).strip.sub(/^,\s*"/, ', "')
end

def ask_with_default(question, color, default)
  return default unless $stdin.tty?
  question = (question.split("?") << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

def git_repo_specified?
  git_repo_url != "skip" && !git_repo_url.strip.empty?
end

def preexisting_git_repo?
  @preexisting_git_repo ||= (File.exist?(".git") || :nope)
  @preexisting_git_repo == true
end

def any_local_git_commits?
  system("git log &> /dev/null")
end

def run_with_clean_bundler_env(cmd)
  success = if defined?(Bundler)
              Bundler.with_unbundled_env { run(cmd) }
            else
              run(cmd)
            end
  unless success
    puts "Command failed, exiting: #{cmd}"
    exit(1)
  end
end

def run_rubocop_autocorrections
  run_with_clean_bundler_env "bin/rubocop -A --fail-level A > /dev/null || true"
end

def create_initial_migration
  return if Dir["db/migrate/**/*.rb"].any?
  run_with_clean_bundler_env "bin/rails generate migration initial_migration"
  run_with_clean_bundler_env "bin/rake db:migrate"
end

apply_template!
