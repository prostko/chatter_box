class AddDiscoverPostsView < ActiveRecord::Migration[7.2]
  def change
    execute <<~SQL
      CREATE MATERIALIZED VIEW discover_posts AS
      SELECT 
        posts.id,
        posts.title,
        posts.body,
        posts.created_at,
        posts.updated_at,
        posts.deleted_at,
        users.id as author_id,
        users.username as author_username,
        users.email as author_email,
        COALESCE(post_cached_ratings.average_rating, 0.0) as cached_average_rating,
        COALESCE(post_cached_ratings.total_rating_count, 0) as cached_total_rating_count,
        COALESCE(post_cached_view_counts.view_count, 0) as cached_view_count
      FROM posts
      LEFT JOIN authors ON posts.id = authors.post_id
      LEFT JOIN users ON authors.user_id = users.id
      LEFT JOIN post_cached_ratings ON posts.id = post_cached_ratings.post_id
      LEFT JOIN post_cached_view_counts ON posts.id = post_cached_view_counts.post_id
      WHERE posts.deleted_at IS NULL
    SQL

    add_index :discover_posts, :author_id
    add_index :discover_posts, :cached_average_rating
    add_index :discover_posts, :cached_view_count
    add_index :discover_posts, :created_at
  end

  def down
    execute "DROP MATERIALIZED VIEW IF EXISTS discover_posts"
  end
end
