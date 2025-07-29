class Api::V1::Users::RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
    @rating = @user.ratings.find(params[:id])
    render json: { rating: @rating }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Rating not found' }, status: :not_found
  end

  def create
    @rating = @user.ratings.create(rating_params)
    render json: { rating: @rating }, status: :created
  end

  def update
    @rating = @user.ratings.find(params[:id])
    @rating.update(rating_params)
    render json: { rating: @rating }, status: :ok
  end
  
  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def rating_params
    params.require(:rating).permit(:rating, :post_id, :user_id)
  end
end