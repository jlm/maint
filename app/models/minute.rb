class Minute < ActiveRecord::Base
	belongs_to :item
	belongs_to :meeting
	validates :date, presence: true, unless: "Rails.application.config.importing"
end
