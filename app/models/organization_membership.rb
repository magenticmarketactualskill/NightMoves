class OrganizationMembership < ApplicationRecord
  # Enums
  enum :role, { member: 0, admin: 1, owner: 2 }

  # Associations
  belongs_to :organization
  belongs_to :user

  # Validations
  validates :user_id, uniqueness: { scope: :organization_id }
end
