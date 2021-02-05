insert_into_file \
  "config/environments/test.rb",
  after: /config\.action_mailer\.delivery_method = :test\n/ do

  <<-RUBY

  # Ensure mailer works in test
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: "localhost:#{ENV.fetch('PORT', 3000)}" }
  config.action_mailer.asset_host = "http://localhost:#{ENV.fetch('PORT', 3000)}"
  RUBY
end

insert_into_file "config/environments/test.rb", before: /^end/ do
  <<-RUBY

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.raise = true # raise an error if n+1 query occurs
  end
  RUBY
end
