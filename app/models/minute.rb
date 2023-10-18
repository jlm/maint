class Minute < ApplicationRecord
  belongs_to :item
  belongs_to :meeting
  belongs_to :minst
  validates :date, presence: true, unless: -> { Rails.application.config.importing }
  scope :date_valid, -> { where.not(date: nil) }
end
