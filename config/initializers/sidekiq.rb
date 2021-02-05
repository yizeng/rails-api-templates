require "sidekiq_unique_jobs/web" # this includes "sidekiq/web" already.
require "sidekiq-scheduler/web"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL_SIDEKIQ") { "redis://localhost:6379/1" } }
  config.death_handlers << lambda { |job, _ex|
    digest = job["unique_digest"]
    SidekiqUniqueJobs::Digests.delete_by_digest(digest) if digest
  }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL_SIDEKIQ") { "redis://localhost:6379/1" } }
end
