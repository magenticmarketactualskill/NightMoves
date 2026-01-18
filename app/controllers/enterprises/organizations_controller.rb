# frozen_string_literal: true

class Enterprises::OrganizationsController < Enterprises::BaseController
  skip_before_action :set_organization, only: [:new, :create]

  def show
    redirect_to new_enterprises_organization_path unless @organization
  end

  def new
    if current_user.organizations.any?
      redirect_to enterprises_organization_path, notice: "You already have an organization."
      return
    end
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      @organization.organization_memberships.create!(user: current_user, role: :owner)
      redirect_to enterprises_dashboard_path, notice: "Organization created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @organization
  end

  def update
    authorize @organization
    if @organization.update(organization_params)
      redirect_to enterprises_organization_path, notice: "Organization updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :description, :website, :billing_email, :logo_url)
  end
end
