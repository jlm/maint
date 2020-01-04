class Import < ApplicationRecord
	validates :filename, presence: true
end
