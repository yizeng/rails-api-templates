mailer_regex = /config\.action_mailer\.raise_delivery_errors = false\n/

comment_lines "config/environments/development.rb", mailer_regex
insert_into_file "config/environments/development.rb", after: mailer_regex do
  <<-RUBY

  # Ensure mailer works in development.
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: "localhost:\#{ENV.fetch('PORT', 3000)}" }
  config.action_mailer.asset_host = "http://localhost:#\{ENV.fetch('PORT', 3000)}"
  RUBY
end

insert_into_file "config/environments/development.rb", before: /^end/ do
  <<-RUBY

  if ENV["RAILS_LOG_TO_STDOUT"].blank?
    # Set up logger rotation for 2 files * 2 MB. https://stackoverflow.com/a/37499712/1177636
    config.logger = ActiveSupport::Logger.new(Rails.root.join("log", "\#{Rails.env}.log"), 2, 2 * 1024 * 1024)
    config.log_level = :debug
  end
  RUBY
end

gsub_file "config/environments/development.rb",
          "join('tmp', 'caching-dev.txt')",
          'join("tmp/caching-dev.txt")'
gsub_file "config/environments/development.rb",
          "config.cache_store = :memory_store",
          'config.cache_store = :redis_cache_store, { url: ENV.fetch("REDIS_URL_CACHING") { "redis://localhost:6379/0" } }'

