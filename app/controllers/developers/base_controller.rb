# frozen_string_literal: true

class Developers::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_developer!

  private

  def require_developer!
    unless current_user.developer?
      flash[:alert] = "You must be a developer to access this area."
      redirect_to root_path
    end
  end
end
