class Transaction < ApplicationRecord
  PLATFORM_FEE_PERCENTAGE = 0.15

  # Enums
  enum :status, { pending: 0, completed: 1, failed: 2, refunded: 3 }
  enum :transaction_type, { license_purchase: 0, subscription_payment: 1, renewal: 2 }

  # Associations
  belongs_to :commercial_license, optional: true
  belongs_to :subscription, optional: true
  belongs_to :organization

  # Validations
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :completed, -> { where(status: :completed) }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  before_save :calculate_fees

  def amount_dollars
    amount_cents / 100.0
  end

  def platform_fee_dollars
    platform_fee_cents / 100.0 if platform_fee_cents
  end

  def developer_payout_dollars
    developer_payout_cents / 100.0 if developer_payout_cents
  end

  private

  def calculate_fees
    return unless amount_cents.present?

    self.platform_fee_cents ||= (amount_cents * PLATFORM_FEE_PERCENTAGE).round
    self.developer_payout_cents ||= amount_cents - platform_fee_cents
  end
end
