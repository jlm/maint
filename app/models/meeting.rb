class Meeting < ActiveRecord::Base
	has_many :minutes, as: :minuteable
	has_and_belongs_to_many :minutes
end
