# Configure TurnstileMini to use localhost Redis
TurnstileMini.configure do |config|
  config.redis_servers = { url: 'redis://localhost:6379/1'}
end 