class Minute < ActiveRecord::Base
	belongs_to :minuteable, polymorphic: true
	has_and_belongs_to_many :meetings
end
