class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title, limit: 100
      t.string :body, limit: 1000

      t.timestamp :deleted_at, null: true
      t.timestamp :published_at, null: true

      t.timestamps
    end
  end
end
