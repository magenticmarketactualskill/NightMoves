class Payout < ApplicationRecord
  # Enums
  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }

  # Associations
  belongs_to :developer, class_name: "User", inverse_of: :payouts

  # Validations
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :period_start, presence: true
  validates :period_end, presence: true
  validates :stripe_payout_id, uniqueness: true, allow_blank: true

  # Scopes
  scope :completed, -> { where(status: :completed) }
  scope :pending, -> { where(status: :pending) }
  scope :recent, -> { order(created_at: :desc) }

  def amount_dollars
    amount_cents / 100.0
  end

  def period_range
    "#{period_start.strftime('%b %d')} - #{period_end.strftime('%b %d, %Y')}"
  end
end
