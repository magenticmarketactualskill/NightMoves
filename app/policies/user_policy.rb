# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    true
  end

  def update?
    owner? || admin?
  end

  def destroy?
    admin? && !record.admin?
  end

  def impersonate?
    admin? && !record.admin?
  end

  private

  def owner?
    record.id == user&.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if admin?
        scope.all
      else
        scope.where(id: user&.id)
      end
    end
  end
end
