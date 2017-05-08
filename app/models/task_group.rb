class TaskGroup < ActiveRecord::Base
  has_many :people
  delegate :chairs, :vice_chairs, :editors, to: :people
end
