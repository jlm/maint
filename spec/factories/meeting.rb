FactoryBot.define do
  factory :meeting do
    location { Faker::Address.city}
    date { Faker::Time.backward(days: 14) }
    meetingtype { Random.rand > 0.5 ? "Plenary" : "Interim" }
    minutes_url { Faker::Internet.url }
  end
end
