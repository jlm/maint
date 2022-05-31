FactoryBot.define do
  factory :item do
    number { Faker::Number.unique.decimal_part(digits: 4) }
    subject { "#{Faker::Superhero.prefix} #{Faker::Superhero.name} in clause #{Faker::Number.decimal(l_digits: 2)}" }
    date { Faker::Time.backward(days: 14) }
    standard { "#{Faker::Number.number(digits: 3)}.#{Faker::Number.number(digits: 2)}#{("a".."z").to_a.sample}" }
    clause { Faker::Number.number(digits: 2) }
    draft { "D#{Faker::Number.decimal(l_digits: 1)}" }
    minst
  end
end
