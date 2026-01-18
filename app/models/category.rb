class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: :parent_id, dependent: :nullify, inverse_of: :parent
  has_many :components, dependent: :nullify

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :slug, presence: true, uniqueness: true

  # Scopes
  scope :top_level, -> { where(parent_id: nil) }
  scope :ordered, -> { order(position: :asc) }
end
