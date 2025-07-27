class PasswordsController < ApplicationController
  before_action :set_user

  def update
    if !@user
      render json: { 
        error: "We skipped the email verification step", 
        errors: ["User not found (we should really implement the email verification step ;) )"] 
      }, status: :not_found
      return
    end

    if @user.update(user_params)
      render json: { success: true, message: "Your password has been changed" }
    else
      render json: { error: "Password update failed", errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def set_user
      # TODO: When the emails get sent, they will include a validatable token
      # that will be used to find the user, then initiate a session for the user at that point.
      # For now, we're just using the email instead of the session
      @user = Current.user
      @user ||= User.find_by(email: params[:email])
    end

    def user_params
      params.permit(:email, :password, :password_confirmation, :password_challenge)
    end
end
