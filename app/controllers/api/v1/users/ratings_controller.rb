class Api::V1::Users::RatingsController < ApplicationController
  before_action :authenticate!
  before_action :set_user

  def show
    @rating = Post::Rating.find_or_initialize_by(user_id: Current.user.id, post_id: params[:post_id])
    
    render json: { rating: @rating }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Rating not found' }, status: :not_found
  end

  def create
    @rating = Post::Rating.new(user_id: Current.user.id, post_id: params[:post_id], rating: params[:rating])
    
    ActiveRecord::Base.transaction do
      @rating.save!
      PersistAveragePostRating.new(params[:post_id]).call!
    end

    # TODO: Handle errors gracefully

    render json: { rating: @rating }, status: :created
  end

  def update
    @rating = Post::Rating.find_by(user_id: Current.user.id, post_id: params[:post_id])

    raise ActiveRecord::RecordNotFound unless @rating

    ActiveRecord::Base.transaction do
      @rating.update!(rating: params[:rating])
      PersistAveragePostRating.new(params[:post_id]).call!
    end

    # TODO: Handle errors gracefully

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