FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "#{Faker::Internet.username}#{SecureRandom.uuid}" }
    sequence(:email) { |n| Faker::Internet.email }
    password { "password123456" }
    verified { false }
    admin { false }

    trait :admin do
      admin { true }
    end

    trait :with_posts do
      after(:create) do |user|
        create_list(:post, 3, authors: [user])
      end
    end
  end
end 