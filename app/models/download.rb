class Download < ApplicationRecord
  # Associations
  belongs_to :component_version
  belongs_to :user, optional: true
  belongs_to :organization, optional: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :by_organization, ->(org) { where(organization: org) }

  # Callbacks
  after_create :increment_counters

  private

  def increment_counters
    component_version.increment!(:downloads_count)
    component_version.component.increment!(:downloads_count)
  end
end
