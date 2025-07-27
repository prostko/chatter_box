class RegistrationsController < ApplicationController
  skip_before_action :authenticate

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      send_email_verification

      render json: { success: true, message: "Welcome! You have signed up successfully" }
    else
      render json: { error: "Registration failed", errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:registration).permit(:username, :email, :password, :password_confirmation)
    end

    def send_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later

      # TODO: wire up a SMTP server to send the email
      @user.update!(verified: true)
    end
end
