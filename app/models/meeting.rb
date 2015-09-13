class Meeting < ActiveRecord::Base
	has_many :minutes
	has_many :items, through: :minutes
	validates :date, presence: true, uniqueness: { message: "A meeting on that date already exists" }
	validates :meetingtype, format: { with: /\A([iI]nterim|[pP]lenary)\z/, message: "must be Interim or Plenary" }
end
