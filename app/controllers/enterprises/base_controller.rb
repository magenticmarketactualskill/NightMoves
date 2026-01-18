# frozen_string_literal: true

class Enterprises::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_enterprise!
  before_action :set_organization

  private

  def require_enterprise!
    unless current_user.enterprise?
      flash[:alert] = "You must be an enterprise user to access this area."
      redirect_to root_path
    end
  end

  def set_organization
    @organization = current_user.organizations.first
  end

  def require_organization!
    unless @organization.present?
      flash[:notice] = "Please create an organization first."
      redirect_to new_enterprises_organization_path
    end
  end
end
