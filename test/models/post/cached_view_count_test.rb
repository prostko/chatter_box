# == Schema Information
#
# Table name: post_cached_view_counts
#
#  id         :bigint           not null, primary key
#  view_count :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#
# Indexes
#
#  index_post_cached_view_counts_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#
require "test_helper"

class Post::CachedViewCountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
