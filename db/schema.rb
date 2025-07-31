# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_07_31_192655) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_authors_on_post_id"
    t.index ["user_id"], name: "index_authors_on_user_id"
  end

  create_table "post_cached_ratings", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.float "average_rating", default: 0.0
    t.integer "total_rating_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_cached_ratings_on_post_id"
  end

  create_table "post_cached_view_counts", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.integer "view_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_cached_view_counts_on_post_id"
  end

  create_table "post_ratings", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_ratings_on_post_id"
    t.index ["user_id"], name: "index_post_ratings_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", limit: 100
    t.string "body", limit: 1000
    t.datetime "deleted_at", precision: nil
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["updated_at"], name: "index_posts_on_updated_at", order: :desc
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "authors", "posts"
  add_foreign_key "authors", "users"
  add_foreign_key "post_cached_ratings", "posts"
  add_foreign_key "post_cached_view_counts", "posts"
  add_foreign_key "post_ratings", "posts"
  add_foreign_key "post_ratings", "users"
  add_foreign_key "sessions", "users"
end
