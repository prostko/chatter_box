class Api::V1::Posts::RatingsController < ApplicationController
  def index    
    post = Post.includes(:ratings).find(params[:post_id])
    
    response = {
      average_rating: post.average_rating,
      rating_count: post.ratings.count
    }
    
    render json: response, status: :ok
  end
end