FactoryBot.define do
    factory :post_view_count, class: 'Post::CachedViewCount' do
      association :post
      view_count { 0 }
    end
  end 