class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate

  private
    def authenticate
      return if registrations?
        
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      else
        redirect_to '/sign_in'
      end
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end

    def registrations?
      if request.get? && (['/sign_in', '/sign_up', '/password_reset'].include?(request.path))
        return true
      end

      if request.patch? && (['/password', '/identity/email'].include?(request.path))
        return true
      end

      false
    end
end
