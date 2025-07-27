class AdminApi::V1::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all
    render json: @users
  end
end