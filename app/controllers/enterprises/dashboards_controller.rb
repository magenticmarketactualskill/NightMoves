# frozen_string_literal: true

class Enterprises::DashboardsController < Enterprises::BaseController
  before_action :require_organization!

  def show
    @licenses = @organization.commercial_licenses.active.includes(:component).limit(5)
    @total_licenses = @organization.commercial_licenses.active.count
    @subscription = @organization.current_subscription
    @team_members = @organization.users.limit(5)
    @recent_downloads = @organization.downloads.includes(component_version: :component).recent.limit(10)
  end
end
