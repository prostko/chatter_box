class Api::V1::Posts::RatingsController < ApplicationController
  def index    
    post = Post.includes(:cached_rating).find(params[:post_id])
    cached_rating = Post::CachedRating.select(:average_rating, :total_rating_count).find_by(post_id: post.id)

    response = {
      average_rating: cached_rating&.average_rating || 0.0,
      rating_count: cached_rating&.total_rating_count || 0
    }
    
    render json: response, status: :ok
  end
end