class Api::V1::Posts::ViewsController < ApplicationController
  def create
    PersistViewCount.new(params[:post_id]).call!
    head :ok
  end

  def index
    view_count_record = Post::CachedViewCount.find_or_initialize_by(post_id: params[:post_id])
    render json: { view_count: view_count_record.view_count }
  end
end