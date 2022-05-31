class TaskGroup < ApplicationRecord
  has_many :people
  # delegate :chair, :vice_chairs, :editors, to: :people
  delegate :vice_chairs, to: :people
  has_many :projects

  belongs_to :chair
end
