FactoryBot.define do
  factory :post_rating, class: 'Post::Rating' do
    association :post
    association :user
    rating { rand(1..5) }

    trait :five_star do
      rating { 5 }
    end

    trait :one_star do
      rating { 1 }
    end
  end
end 