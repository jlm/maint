FactoryBot.define do
  factory :item do
    number { 9876 }
    subject { "An interesting problem" }
    date { Time.now }
    standard { "802.4b" }
    clause { 2 }
    draft { "" }
    minst
  end
end