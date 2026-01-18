# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    member? || admin?
  end

  def create?
    enterprise?
  end

  def update?
    org_admin? || admin?
  end

  def destroy?
    owner? || admin?
  end

  def manage_members?
    org_admin? || admin?
  end

  private

  def member?
    record.users.include?(user)
  end

  def org_admin?
    membership&.admin? || owner?
  end

  def owner?
    membership&.owner?
  end

  def membership
    @membership ||= record.organization_memberships.find_by(user: user)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if admin?
        scope.all
      else
        scope.joins(:organization_memberships).where(organization_memberships: { user_id: user&.id })
      end
    end
  end
end
