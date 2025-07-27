class Api::V1::CurrentUserController < ApplicationController
  def show
    render json: { user: Current.user }
  end
end