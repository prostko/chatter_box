class SessionsController < ApplicationController
  before_action :authenticate, only: %i[destroy]
  before_action :set_session, only: :destroy

  def new
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
      render json: { success: true, message: "Signed in successfully" }

    else
      render json: { error: "That email or password is incorrect" }, status: :unauthorized
    end
  end

  def destroy
    @session.destroy
    redirect_to root_path
  end

  private
    def set_session
      # TODO: we should really logout with the session ID, but for the sake of time
      # we're clearing the users sessions
      @session = Current.user.sessions.first
    end
end
