# Configure TurnstileMini to use localhost Redis
TurnstileMini.configure do |config|
  config.redis_servers = { 
    url: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/1' } 
  }
end 