class Item < ApplicationRecord
  has_many :minutes
  has_many :meetings, through: :minutes
  belongs_to :minst
  has_one :request, dependent: :destroy
  # :number, :date, :standard, :clause, :subject, :draft
  validates :number, presence: true, format: {with: /\A\d{4}\z/, message: "must be 4 decimal digits"}, uniqueness: true
  validates :date, presence: true
  validates :standard, presence: true, length: {in: 3..50}
  validates :subject, presence: true, length: {maximum: 200}, unless: -> { Rails.application.config.importing }
  before_save {
    lastminst = minutes.blank? ? nil : minutes.date_valid.order(:date, :id).last.minst
    self.minst = lastminst unless lastminst.nil?
  }

  CLOSED_CODES = %w[P J W]
  scope :closed, -> { joins(:minst).where("minsts.code IN (?)", CLOSED_CODES) }
  scope :open, -> { joins(:minst).where.not("minsts.code IN (?)", CLOSED_CODES) }
  scope :review, -> { joins(:minst).where.not("minsts.code IN (?)", CLOSED_CODES + ["V"]) }

  def is_closed?
    minst && (CLOSED_CODES.include? minst.code)
  end
end
