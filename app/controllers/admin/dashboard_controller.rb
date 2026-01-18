# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  def index
    @total_users = User.count
    @total_developers = User.developers.count
    @total_enterprises = User.enterprises.count
    @total_components = Component.count
    @published_components = Component.published.count
    @pending_components = Component.pending_review.count
    @total_organizations = Organization.count
    @total_transactions = Transaction.completed.sum(:amount_cents)
    @active_subscriptions = Subscription.active.count

    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_components = Component.includes(:developer).order(created_at: :desc).limit(5)
  end
end
