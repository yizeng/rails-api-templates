insert_into_file "spec/rails_helper.rb", before: /^end/ do
  <<-RUBY

  if Bullet.enable?
    config.before do
      Bullet.start_request
    end

    config.after do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end

  config.include FactoryBot::Syntax::Methods
  RUBY
end

insert_into_file "spec/rails_helper.rb" do
  <<-RUBY

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  RUBY
end

insert_into_file "spec/spec_helper.rb", before: /^end/ do
  <<-RUBY

  config.order = :random

  Kernel.srand config.seed

  config.before(:suite) do
    Rails.application.load_seed # loading seeds.rb to seed the presets.
  end
  RUBY
end

insert_into_file "spec/spec_helper.rb", before: /^RSpec.configure/ do
  <<-RUBY
  require "simplecov"

  SimpleCov.start "rails" do
    add_filter do |source_file|
      source_file.lines.count < 5
    end
  end

  require "codecov"

  SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV["CODECOV_TOKEN"]

  RUBY
end

gsub_file "config/initializers/rswag-ui.rb", /API V1 Docs/ do
  "#{app_name.humanize.titleize.gsub(/Api/, 'API')} V1 Docs"
end

gsub_file "spec/swagger_helper.rb", /API V1/ do
  "#{app_name.humanize.titleize.gsub(/Api/, 'API')} V1"
end

