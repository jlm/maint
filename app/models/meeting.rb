class Meeting < ApplicationRecord
	has_many :minutes
	has_many :items, through: :minutes
	has_many :motions
	validates :date, presence: true, uniqueness: { message: "A meeting on that date already exists" }
	validates :meetingtype, format: { with: /\A([iI]nterim|[pP]lenary|[cC]oncall)\z/, message: "must be Interim, Plenary or Concall" }, unless: "Rails.application.config.importing"
end
