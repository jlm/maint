FactoryBot.define do
  factory :task_group do
    chair
    abbrev { generate_text(3) }
    name { Faker::Movie.title }
    page_url { "https://www.ieee802.org/#{Faker::Number.between(from: 0, to: 14)}/groups/#{Faker::Number.between(from: 1, to: 40)}/" }
  end
end
