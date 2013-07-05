Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/10', namespace: 'inv_tagger' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/10', namespace: 'inv_tagger' }
end
