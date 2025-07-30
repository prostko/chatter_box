class CreatePostCachedRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :post_cached_ratings do |t|
      t.references :post, null: false, foreign_key: true
      t.float :average_rating, default: 0.0
      t.integer :total_rating_count, default: 0

      t.timestamps
    end
  end
end
