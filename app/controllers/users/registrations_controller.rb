# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :bio, :website, :github_username, :avatar_url])
  end

  def after_sign_up_path_for(resource)
    case resource.role
    when "developer"
      developers_dashboard_path
    when "enterprise"
      new_enterprises_organization_path
    else
      root_path
    end
  end

  def build_resource(hash = {})
    super
    # Set default role from params if provided
    if params[:role].present? && %w[developer enterprise].include?(params[:role])
      self.resource.role = params[:role]
    end
  end
end
