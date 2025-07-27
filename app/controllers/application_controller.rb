class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate

  def authenticate   
    Current.session = Session.find_by_id(cookies.signed[:session_token])
  end

  def authenticate!      
    authenticate

    redirect_to '/sign_in' unless Current.session
  end

  def authenticate_admin!
    authenticate!

    redirect_to '/' unless Current.user.admin
  end


  private

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end
end
