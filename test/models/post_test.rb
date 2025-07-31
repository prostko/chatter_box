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
# Indexes
#
#  index_posts_on_updated_at  (updated_at)
#
require "test_helper"

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
