class PersistAveragePostRating
  def initialize(post_id)
    @rating_records = Post::Rating.where(post_id: post_id)
    @average_rating_record = Post::CachedRating.find_or_initialize_by(post_id: post_id)
  end

  def call!
    calculate_average_rating
    count_ratings

    persist_average_rating!
  end

  private 

  def calculate_average_rating
    @average = rating_records.average(:rating).to_f.round(1)
  end

  def count_ratings
    @count = rating_records.count
  end

  def persist_average_rating!
    average_rating_record.update!(
      average_rating: @average,
      total_rating_count: @count
    )
  end

  attr_reader :rating_records, :average_rating_record
end