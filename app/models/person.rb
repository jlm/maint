class Person < ApplicationRecord
  belongs_to :task_group, optional: true
  self.inheritance_column = :role

  validates :role, presence: true

  scope :chairs, (-> { where(role: "Chair") })
  scope :vice_chairs, (-> { where(role: "ViceChair") })
  scope :editors, (-> { where(role: "Editor") })

  def full_name
    "#{first_name} #{last_name}"
  end

  class << self
    def roles
      %w[Chair ViceChair Editor]
    end
  end
end
