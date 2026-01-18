class Review < ApplicationRecord
  # Associations
  belongs_to :component
  belongs_to :user

  # Validations
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :component_id, message: "has already reviewed this component" }
  validates :title, length: { maximum: 100 }
  validates :body, length: { maximum: 5000 }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :helpful, -> { order(helpful_count: :desc) }
  scope :by_rating, ->(rating) { where(rating: rating) }

  # Callbacks
  after_save :update_component_rating
  after_destroy :update_component_rating

  def mark_helpful!
    increment!(:helpful_count)
  end

  private

  def update_component_rating
    # Trigger component to recalculate average rating if needed
  end
end
