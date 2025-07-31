FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post Title #{n}" }
    sequence(:body) { |n| "This is the body content for post #{n}. It contains some sample text to make the post more realistic." }
    published_at { Time.current }

    trait :unpublished do
      published_at { nil }
    end

    trait :deleted do
      deleted_at { Time.current }
    end

    trait :with_ratings do
      after(:create) do |post|
        create_list(:post_rating, 3, post: post)
      end
    end
  end
end 