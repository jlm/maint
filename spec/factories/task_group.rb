FactoryBot.define do
  factory :task_group do
    chair
    abbrev { 'PRN' }
    name { 'Pruning' }
    page_url { 'https://www.ieee802.org/43/task_groups/pruning/' }
  end
end
