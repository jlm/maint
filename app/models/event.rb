class Event < ActiveRecord::Base
  belongs_to :project
  validates :name, presence: true
end
