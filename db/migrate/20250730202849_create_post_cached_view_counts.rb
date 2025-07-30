class CreatePostCachedViewCounts < ActiveRecord::Migration[7.2]
  def change
    create_table :post_cached_view_counts do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :view_count, default: 0

      t.timestamps
    end
  end
end
