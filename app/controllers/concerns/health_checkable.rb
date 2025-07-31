module HealthCheckable
  extend ActiveSupport::Concern
  
  included do
    skip_before_action :authenticate, only: [:health]
  end
  
  def health
    checks = {
      rails: true,
      database: database_healthy?,
      redis: redis_healthy?,
      environment: Rails.env,
      timestamp: Time.current.iso8601
    }
    
    if checks.values.all? { |v| v == true }
      render json: { status: "healthy", checks: checks }, status: :ok
    else
      render json: { status: "unhealthy", checks: checks }, status: :service_unavailable
    end
  end
  
  private
  
  def database_healthy?
    ActiveRecord::Base.connection.execute("SELECT 1")
    true
  rescue => e
    Rails.logger.error "Database health check failed: #{e.message}"
    false
  end
  
  def redis_healthy?
    Redis.new.ping == "PONG"
  rescue => e
    Rails.logger.error "Redis health check failed: #{e.message}"
    false
  end
end 