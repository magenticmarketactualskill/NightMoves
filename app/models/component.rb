class Component < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Enums
  enum :license_type, { mit: 0, apache2: 1, proprietary: 2 }
  enum :status, { draft: 0, pending_review: 1, published: 2, archived: 3 }

  # Associations
  belongs_to :developer, class_name: "User", inverse_of: :components
  belongs_to :category, optional: true, counter_cache: true
  has_many :versions, class_name: "ComponentVersion", dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :commercial_licenses, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: true
  validates :tagline, length: { maximum: 150 }

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :featured, -> { where(featured: true) }
  scope :recent, -> { order(published_at: :desc) }
  scope :popular, -> { order(downloads_count: :desc) }

  def latest_version
    versions.published.order(created_at: :desc).first
  end

  def average_rating
    reviews.average(:rating)&.round(1)
  end
end
