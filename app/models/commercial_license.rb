class CommercialLicense < ApplicationRecord
  # Enums
  enum :status, { active: 0, expired: 1, revoked: 2 }

  # Associations
  belongs_to :component
  belongs_to :organization
  has_many :transactions, dependent: :nullify

  # Validations
  validates :license_key, presence: true, uniqueness: true
  validates :price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :seats, numericality: { greater_than: 0 }

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :expiring_soon, -> { active.where("expires_at < ?", 30.days.from_now) }

  # Callbacks
  before_validation :generate_license_key, on: :create

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def valid_license?
    active? && !expired?
  end

  private

  def generate_license_key
    self.license_key ||= SecureRandom.uuid
  end
end
