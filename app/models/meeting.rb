class Meeting < ActiveRecord::Base
	has_many :minutes, as: :minuteable
end
