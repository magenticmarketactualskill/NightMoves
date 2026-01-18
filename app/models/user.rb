class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enums
  enum :role, { developer: 0, enterprise: 1, admin: 2 }

  # Associations
  has_many :components, foreign_key: :developer_id, dependent: :destroy, inverse_of: :developer
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :reviews, dependent: :destroy
  has_many :payouts, foreign_key: :developer_id, dependent: :destroy, inverse_of: :developer

  # Validations
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :github_username, uniqueness: true, allow_blank: true

  # Scopes
  scope :developers, -> { where(role: :developer) }
  scope :enterprises, -> { where(role: :enterprise) }
  scope :admins, -> { where(role: :admin) }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display_name
    full_name.presence || email.split("@").first
  end
end
