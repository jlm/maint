FactoryBot.define do
  factory :request do
    date { Faker::Date.backward(days: 14) }
    name { Faker::Name.name }
    company { Faker::Company.name }
    email { Faker::Internet.safe_email }
    standard { "#{Faker::Number.number(digits: 3)}.#{Faker::Number.number(digits: 2)}#{('a'..'z').to_a.sample}" }
    clauseno { "#{Faker::Number.decimal(l_digits: 2)}" }
    clausetitle { Faker::Lorem.sentence(word_count: 3, supplemental: true)[..-1] }
    rationale { Faker::Lorem.paragraph }
    proposal { Faker::Lorem.paragraph }
    impact { Faker::Lorem.sentence }
  end
end
