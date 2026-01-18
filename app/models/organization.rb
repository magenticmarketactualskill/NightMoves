class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships
  has_many :subscriptions, dependent: :destroy
  has_many :commercial_licenses, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :downloads, dependent: :nullify

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: true

  # Scopes
  scope :with_active_subscription, -> { joins(:subscriptions).where(subscriptions: { status: :active }) }

  def current_subscription
    subscriptions.active.order(created_at: :desc).first
  end

  def owner
    organization_memberships.find_by(role: :owner)&.user
  end
end
