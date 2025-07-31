class PersistViewCount
  def initialize(post_id)
    @post_id = post_id
  end
  
  def call!
    ActiveRecord::Base.transaction do
      view_count = Post::CachedViewCount.find_or_create_by(post_id: post_id)
      view_count.increment!(:view_count)
    end
  end

  private

  attr_reader :post_id
end