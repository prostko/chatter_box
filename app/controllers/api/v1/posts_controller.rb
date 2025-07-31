class Api::V1::PostsController < ApplicationController
  # Implementing pagination:
  # This is simple offset/limit based pagination to support the infinite scroll on the discover page
  # using offset instead of cursor(or keyset) because offset is better for infinite scroll, 
  # even though it isn't as performant for large datasets


  # Here's an example of the query plan for the index scan on the posts table
  # EXPLAIN SELECT "posts".* FROM "posts" ORDER BY "posts"."updated_at" DESC LIMIT $1 OFFSET $2 [["LIMIT", 10], ["OFFSET", 0]]
  # QUERY PLAN
  # -----------------------------------------------------------------------
  #  Limit  (cost=73.77..73.79 rows=10 width=320)
  #    ->  Sort  (cost=73.77..76.28 rows=1005 width=320)
  #          Sort Key: updated_at DESC
  #          ->  Seq Scan on posts  (cost=0.00..52.05 rows=1005 width=320)
  # (4 rows)
  
  # EXPLAIN SELECT "authors".* FROM "authors" WHERE "authors"."post_id" IN ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) [["post_id", 1024], ["post_id", 2], ["post_id", 1], ["post_id", 1023], ["post_id", 1022], ["post_id", 1021], ["post_id", 1020], ["post_id", 1019], ["post_id", 1018], ["post_id", 1017]]
  #                                         QUERY PLAN
  # -------------------------------------------------------------------------------------------
  #  Index Scan using index_authors_on_post_id on authors  (cost=0.28..12.73 rows=10 width=40)
  #    Index Cond: (post_id = ANY ('{1024,2,1,1023,1022,1021,1020,1019,1018,1017}'::bigint[]))
  # (2 rows)
  
  # EXPLAIN SELECT "users".* FROM "users" WHERE "users"."id" = $1 [["id", 4]]
  #                                 QUERY PLAN
  # --------------------------------------------------------------------------
  #  Index Scan using users_pkey on users  (cost=0.15..8.17 rows=1 width=122)
  #    Index Cond: (id = '4'::bigint)
  # (2 rows)
  
  # EXPLAIN SELECT "post_ratings".* FROM "post_ratings" WHERE "post_ratings"."post_id" IN ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) [["post_id", 1024], ["post_id", 2], ["post_id", 1], ["post_id", 1023], ["post_id", 1022], ["post_id", 1021], ["post_id", 1020], ["post_id", 1019], ["post_id", 1018], ["post_id", 1017]]
  #                                            QUERY PLAN
  # -------------------------------------------------------------------------------------------------
  #  Bitmap Heap Scan on post_ratings  (cost=4.61..15.45 rows=56 width=44)
  #    Recheck Cond: (post_id = ANY ('{1024,2,1,1023,1022,1021,1020,1019,1018,1017}'::bigint[]))
  #    ->  Bitmap Index Scan on index_post_ratings_on_post_id  (cost=0.00..4.57 rows=56 width=0)
  #          Index Cond: (post_id = ANY ('{1024,2,1,1023,1022,1021,1020,1019,1018,1017}'::bigint[]))
  # (4 rows)

  #
  # The main performance issue is the sequential scan on posts table when ordering by updated_at. 
  # Adding an index to the updated_at column will help
  # THere is also an argument for splitting the requests into concurrent database requests, but first thing first is to add an index and check the metrics 
#

#   Here is the query plan after the improvementEXPLAIN SELECT "posts".* FROM "posts" ORDER BY "posts"."updated_at" DESC LIMIT $1 OFFSET $2 [["LIMIT", 10], ["OFFSET", 0]]
#   QUERY PLAN
# ---------------------------------------------------------------------------------------------------
# Limit  (cost=0.28..1.06 rows=10 width=320)
# ->  Index Scan using index_posts_on_updated_at on posts  (cost=0.28..80.64 rows=1024 width=320)
# (2 rows)

# EXPLAIN SELECT "authors".* FROM "authors" WHERE "authors"."post_id" IN ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) [["post_id", 1024], ["post_id", 2], ["post_id", 1], ["post_id", 1023], ["post_id", 1022], ["post_id", 1021], ["post_id", 1020], ["post_id", 1019], ["post_id", 1018], ["post_id", 1017]]
# QUERY PLAN
# -------------------------------------------------------------------------------------------
# Index Scan using index_authors_on_post_id on authors  (cost=0.28..12.73 rows=10 width=40)
# Index Cond: (post_id = ANY ('{1024,2,1,1023,1022,1021,1020,1019,1018,1017}'::bigint[]))
# (2 rows)

# EXPLAIN SELECT "users".* FROM "users" WHERE "users"."id" = $1 [["id", 4]]
# QUERY PLAN
# --------------------------------------------------------------------------
# Index Scan using users_pkey on users  (cost=0.15..8.17 rows=1 width=122)
# Index Cond: (id = '4'::bigint)
# (2 rows)

# EXPLAIN SELECT "post_ratings".* FROM "post_ratings" WHERE "post_ratings"."post_id" IN ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) [["post_id", 1024], ["post_id", 2], ["post_id", 1], ["post_id", 1023], ["post_id", 1022], ["post_id", 1021], ["post_id", 1020], ["post_id", 1019], ["post_id", 1018], ["post_id", 1017]]
#  QUERY PLAN
# -------------------------------------------------------------------------------------------------
# Bitmap Heap Scan on post_ratings  (cost=4.61..15.45 rows=56 width=44)
# Recheck Cond: (post_id = ANY ('{1024,2,1,1023,1022,1021,1020,1019,1018,1017}'::bigint[]))
# ->  Bitmap Index Scan on index_post_ratings_on_post_id  (cost=0.00..4.57 rows=56 width=0)
# Index Cond: (post_id = ANY ('{1024,2,1,1023,1022,1021,1020,1019,1018,1017}'::bigint[]))
# (4 rows)
  def index
    @posts = Post.includes(:users, :ratings)

    page = params[:page].to_i || 1
    per_page = params[:per_page].to_i || 10

    # only set the total post count on the first request
    if request.headers['X-Total-Count'].blank?
        response.headers['X-Total-Count'] = Post.count
    end

    @posts = @posts.offset((page - 1) * per_page).limit(per_page)

    @posts = @posts.order(updated_at: :desc)

    render json: {posts: @posts.map { |post| post_serializer(post) }}
  end

  def show
    @post = Post.find(params[:id])
    data = post_serializer(@post) 

    data[:view_count] = @post.total_view_count

    render json: { post: data }
  end

  private

  def post_serializer(post)
    {
      id: post.id,
      title: post.title,
      body: post.body,
      published_at: post.updated_at,
      published_date: post.updated_at.strftime('%B %d, %Y'),
      href: "/discover/#{post.id}",
      can_edit: post.users.map(&:id).include?(Current.user&.id),
      edit_url: "/users/#{Current.user&.id}/posts/#{post.id}/edit",
      authors: post.users.map do |user| 
        {
            id: user.id,
            username: user.username,
        }
      end,
    }
  end
end