class Import < ActiveRecord::Base
	validates :filename, presence: true
end
