class Identity::PasswordResetsController < ApplicationController
  skip_before_action :authenticate

  before_action :set_user, only: %i[ edit update ]

  def new
  end

  def edit
  end

  def create
    if @user = User.find_by(email: params[:email], verified: true)
      send_password_reset_email
      redirect_to sign_in_path, notice: "Check your email for reset instructions"
    else
      redirect_to new_identity_password_reset_path, alert: "You can't reset your password until you verify your email"
    end
  end

  def update
    if @user.update(user_params)
      render json: { success: true, message: "Your password was reset successfully. Please sign in" }
    else
      render json: { error: "Password reset failed", errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def set_user
      # TODO: When the emails get sent, they will include a validatable token
      # that will be used to find the user. 
      # For now, we're just using the email as the token.
      @user = User.find_by(email: params[:email])
    rescue StandardError
      redirect_to new_identity_password_reset_path, alert: "That password reset link is invalid"
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end

    def send_password_reset_email
      UserMailer.with(user: @user).password_reset
    end
end
