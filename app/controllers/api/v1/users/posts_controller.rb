class Api::V1::Users::PostsController < ApplicationController
  def index
    @posts = Post.joins(:users)
                 .where(users: { id: params[:user_id] },
                        posts: { deleted_at: nil })
                 .order(published_at: :desc)

    render json: { posts: @posts.map { |post| post_serializer(post) } }
  end

  def show
    @post = Post.joins(:authors)
                .where(authors: { user_id: params[:user_id] })
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
    end

    render json: { post: @post }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    post = Post.new(post_params)
    post.valid?
    render json: { errors: post.errors }, status: :unprocessable_entity
  end

  def edit
    @post = User.find(params[:user_id]).posts.find(params[:id])

    render json: { post: @post }
  end

  def update
    @post = User.find(params[:user_id]).posts.find(params[:id])
   
    if @post.update(post_params)
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
      published_at: post.created_at,
      published_date: post.created_at.strftime('%B %d, %Y'),
      created_at: post.created_at,
      updated_at: post.updated_at,
      href: "/posts/#{post.id}",
    }
  end
end