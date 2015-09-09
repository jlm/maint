class Item < ActiveRecord::Base
	has_many :minutes, as: :minuteable
	before_save {
		lastminute = self.minutes.where("minutes.DATE is not null").joins(:meetings).order("meetings.DATE").last;
		self.latest_status = lastminute.status unless lastminute.nil?
	}
	scope :closed, -> { where latest_status: ["P", "J", "W"] }
	scope :open, ->   { where.not latest_status: ["P", "J", "W"]  }

	def is_closed?
		["P", "J", "W"].include? self.latest_status
	end
end
