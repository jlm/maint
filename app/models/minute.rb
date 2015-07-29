class Minute < ActiveRecord::Base
	belongs_to :minuteable, polymorphic: true
end
