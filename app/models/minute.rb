class Minute < ActiveRecord::Base
	belongs_to :item
	belongs_to :meeting
	belongs_to :minst
	validates :date, presence: true, unless: "Rails.application.config.importing"
end
