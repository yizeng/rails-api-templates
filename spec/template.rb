insert_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
  <<-RUBY

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
  require "simplecov-cobertura"

  SimpleCov.start "rails" do
    add_filter do |source_file|
      source_file.lines.count < 5
    end
    add_filter("app/channels/application_cable/")
    add_filter("app/mailers/application_mailer.rb")

    add_group("Services", "app/services")
  end

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::CoberturaFormatter
    ]
  )

  RUBY
end
