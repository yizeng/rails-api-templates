uncomment_lines "config/environments/production.rb", /config\.force_ssl = true/
gsub_file "config/environments/production.rb",
          "config.force_ssl = true",
          'config.force_ssl = ENV["RAILS_FORCE_SSL"].present?'
gsub_file "config/environments/production.rb",
          "config.log_level = :debug",
          'config.log_level = :info'

uncomment_lines "config/environments/production.rb", /config\.cache_store = :mem_cache_store/
gsub_file "config/environments/production.rb",
          "config.cache_store = :mem_cache_store",
          'config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL_CACHING"] } if ENV["REDIS_URL_CACHING"].present?'

insert_into_file "config/environments/production.rb", before: /^end/ do
  <<-'RUBY'
  config.logger = Logdna::Ruby.new(ENV["LOGDNA_API_KEY"]) if ENV["LOGDNA_API_KEY"].present?
  RUBY
end
