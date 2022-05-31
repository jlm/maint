FactoryBot.define do
  factory :chair do
    first_name { "Fergal" }
    last_name { "Snowdrop" }
    email { "#{first_name}.#{last_name}@example.com".downcase }
    affiliation { "Important Persons, Inc." }
  end
end
