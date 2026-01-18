# frozen_string_literal: true

class Developers::DashboardsController < Developers::BaseController
  def show
    @components = current_user.components.includes(:category).order(created_at: :desc).limit(5)
    @total_downloads = current_user.components.sum(:downloads_count)
    @total_earnings = current_user.payouts.completed.sum(:amount_cents)
    @pending_earnings = current_user.payouts.pending.sum(:amount_cents)
    @recent_reviews = Review.joins(:component)
                            .where(components: { developer_id: current_user.id })
                            .includes(:user, :component)
                            .order(created_at: :desc)
                            .limit(5)
  end
end
