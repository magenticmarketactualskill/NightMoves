class ComponentVersion < ApplicationRecord
  # Enums
  enum :status, { draft: 0, published: 1, deprecated: 2 }

  # Associations
  belongs_to :component, counter_cache: false
  has_many :downloads, dependent: :destroy

  # Validations
  validates :version, presence: true
  validates :version, uniqueness: { scope: :component_id }

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  after_create :increment_component_downloads, if: :published?

  private

  def increment_component_downloads
    # Placeholder for download tracking logic
  end
end
