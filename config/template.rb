apply "config/application.rb"

copy_file "config/database.yml", force: true
gsub_file "config/database.yml", /app_name/ do
  app_name
end

copy_file "config/puma.rb", force: true
copy_file "config/sidekiq.yml"
remove_file "config/secrets.yml"

copy_file "config/initializers/rotate_log.rb"
copy_file "config/initializers/sidekiq.rb"
copy_file "config/initializers/sidekiq_unique_jobs.rb"
copy_file "config/initializers/version.rb"

gsub_file "config/initializers/filter_parameter_logging.rb", /\[:password\]/ do
  "%w[password secret session cookie csrf]"
end

apply "config/environments/development.rb"
apply "config/environments/production.rb"
apply "config/environments/test.rb"


gsub_file "config/routes.rb", "post '/graphql'", 'post "/api/graphql"'

insert_into_file "config/routes.rb", before: /^end/ do
  <<-'RUBY'

  require "sidekiq_unique_jobs/web" # this includes "sidekiq/web" already.
  require "sidekiq-scheduler/web"

  if Rails.env.production? && ENV["SIDEKIQ_WEB_USERNAME"] && ENV["SIDEKIQ_WEB_PASSWORD"]
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking
      # (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
                                                  ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_WEB_USERNAME"])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
                                                    ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_WEB_PASSWORD"]))
    end
  end

  mount Sidekiq::Web, at: "/sidekiq"
  RUBY
end