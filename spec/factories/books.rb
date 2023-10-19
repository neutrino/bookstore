FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    year_published { Faker::Number.between(from: 1900, to: Time.now.year)  }
    authors { Faker::Book.author  }
    description { Faker::Lorem.sentence }
    genre { Faker::Book.genre }
    association :user
  end
end
