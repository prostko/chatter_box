class CreatePostRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :post_ratings do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
