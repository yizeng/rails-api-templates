SidekiqUniqueJobs.configure do |config|
  config.lock_info = true
  config.enabled = !Rails.env.test?
end
