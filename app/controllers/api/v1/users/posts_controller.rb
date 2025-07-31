class Api::V1::Users::PostsController < ApplicationController
  def index
    page = params[:page].to_i || 1
    per_page = params[:per_page].to_i || 10

    @posts = Post.joins(:users)
                 .where(users: { id: params[:user_id] },
                        posts: { deleted_at: nil })

    # only set the total post count on the first request
    if page == 1
        response.headers['X-Total-Count'] = @posts.count
    end

    @posts = @posts.offset((page - 1) * per_page).limit(per_page)
    
    @posts = @posts.order(updated_at: :desc)

    render json: { posts: @posts.map { |post| post_serializer(post) } }, status: :ok
  end

  def show
    @post = Post.joins(:users)
                .where(users: { id: params[:user_id] })
                .find(params[:id])

    render json: { post: post_serializer(@post) }
  end

  def new
    @post = Post.new

    render json: { post: @post }
  end

  def create
    @post = Post.new(post_params)

    ActiveRecord::Base.transaction do
      @post.save!
      Author.create!(user_id: params[:user_id], post_id: @post.id)
      Post::CachedRating.create!(post_id: @post.id)
    end

    render json: { post: @post }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    post = Post.new(post_params)
    post.valid?
    render json: { errors: post.errors }, status: :unprocessable_entity
  end

  def update
    @post = User.find(params[:user_id]).posts.find(params[:id])
    
    successful_update = false 
    TurnstileMini.lock("post_update_lock:#{@post.id}") do 
      successful_update = @post.update(post_params)
    end

    if successful_update
      render json: { post: @post }, status: :ok
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @post = User.find(params[:user_id]).posts.find(params[:id])
    @post.deleted_at = Time.zone.now

    if @post.save
      render json: { message: 'Post deleted successfully' }, status: :ok
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :published_at)
  end

  def post_serializer(post)
    {
      id: post.id,
      title: post.title,
      body: post.body,
      published_at: post.updated_at,
      published_date: post.updated_at.strftime('%B %d, %Y'),
      href: "/users/#{Current.user.id}/posts/#{post.id}/edit"
    }
  end
end