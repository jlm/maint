class Motion < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :project
  validates :motion_text, presence: true
end
