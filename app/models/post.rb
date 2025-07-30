# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  body         :string(1000)
#  deleted_at   :datetime
#  published_at :datetime
#  title        :string(100)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Post < ApplicationRecord
    has_and_belongs_to_many :users, join_table: :authors
    has_many :ratings, dependent: :destroy, class_name: 'Post::Rating'
    has_one :cached_rating, class_name: 'Post::CachedRating'

    scope :deleted, -> { where.not(deleted_at: nil) }
    scope :active, -> { published.not_deleted }

    validates :title, presence: true, length: { maximum: 100 }
    validates :body, presence: true, length: { maximum: 1000 }

    def average_rating
      cached_rating&.average_rating || 0
    end

    # The following methods are used for soft deletion
    # It would probably be better to use a gem like acts_as_paranoid or similar for this
    def destroy
        self.update(deleted_at: Time.zone.now)
    end

    def delete
        destroy
    end

    def self.delete_all
        update_all(deleted_at: Time.zone.now)
    end

    def self.destroy_all
        update_all(deleted_at: Time.zone.now)
    end
end
