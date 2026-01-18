class Subscription < ApplicationRecord
  # Enums
  enum :plan, { basic: 0, professional: 1, enterprise: 2 }
  enum :status, { active: 0, canceled: 1, past_due: 2, trialing: 3 }

  # Associations
  belongs_to :organization
  has_many :transactions, dependent: :nullify

  # Validations
  validates :stripe_subscription_id, uniqueness: true, allow_blank: true

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :expiring_soon, -> { active.where("current_period_end < ?", 7.days.from_now) }

  def active?
    status == "active" && (current_period_end.nil? || current_period_end > Time.current)
  end
end
