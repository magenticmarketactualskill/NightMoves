# frozen_string_literal: true

class ComponentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.published? || owner? || admin?
  end

  def create?
    developer?
  end

  def update?
    owner? || admin?
  end

  def destroy?
    owner? || admin?
  end

  def publish?
    owner? || admin?
  end

  def feature?
    admin?
  end

  private

  def owner?
    record.developer_id == user&.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if admin?
        scope.all
      else
        scope.published.or(scope.where(developer_id: user&.id))
      end
    end
  end
end
