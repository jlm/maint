class Motion < ApplicationRecord
  belongs_to :meeting
  belongs_to :project
  validates :motion_text, presence: true
end
