class HealthController < ApplicationController
  skip_before_action :authenticate
  
  def show
    # Basic Rails health check
    health_status = Rails.application.routes.recognize_path("/up")
    
    # Add your custom health checks here
    checks = {
      rails: health_status.present?,
      database: database_healthy?,
      redis: redis_healthy?,
      # Add more checks as needed
    }
    
    if checks.values.all?
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