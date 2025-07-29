class Api::V1::PostsController < ApplicationController
  # Implementing pagination:
  # This is simple offset/limit based pagination to support the infinite scroll on the discover page
  # using offset instead of cursor(or keyset) because offset is better for infinite scroll, 
  # even though it isn't as performant for large datasets
  def index
    @posts = Post.includes(:users, :ratings)

    page = params[:page].to_i || 1
    per_page = params[:per_page].to_i || 10

    # only set the total post count on the first request
    if page == 1 
        response.headers['X-Total-Count'] = Post.count
    end

    @posts = @posts.offset((page - 1) * per_page).limit(per_page)

    render json: {posts: @posts.map { |post| post_serializer(post) }}
  end

  private

  def post_serializer(post)
    {
      id: post.id,
      title: post.title,
      body: post.body,
      published_at: post.updated_at,
      published_date: post.updated_at.strftime('%B %d, %Y'),
      rating: 0,
      rating_count: post.ratings.count,
      authors: post.users.map do |user| 
        {
            id: user.id,
            username: user.username,
        }
      end,
    }
  end
end