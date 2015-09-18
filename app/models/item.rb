class Item < ActiveRecord::Base
	has_many :minutes
	has_many :meetings, through: :minutes
	# :number, :date, :standard, :clause, :subject, :draft
	validates :number, presence: true, format: { with: /\A\d{4}\z/, message: "must be 4 decimal digits" }
	validates :date, presence: true
	validates :standard, presence: true, length: { in: 3..50 }
	validates :subject, presence: true, length: { maximum: 200 }, unless: "Rails.application.config.importing"
	before_save {
		lastminute = self.minutes.where("minutes.DATE is not null").joins(:meeting).order("meetings.DATE").last;
		self.latest_status = lastminute.status unless lastminute.nil?
	}
	scope :closed, -> { where latest_status: ["P", "J", "W"] }
	scope :open, ->   { where.not latest_status: ["P", "J", "W"]  }

	def is_closed?
		["P", "J", "W"].include? self.latest_status
	end
end
