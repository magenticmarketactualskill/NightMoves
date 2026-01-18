# frozen_string_literal: true

class Developers::ComponentsController < Developers::BaseController
  before_action :set_component, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @components = pagy(current_user.components.includes(:category).order(created_at: :desc))
  end

  def show
    @versions = @component.versions.order(created_at: :desc)
  end

  def new
    @component = current_user.components.build
    @categories = Category.all.ordered
  end

  def create
    @component = current_user.components.build(component_params)

    if @component.save
      redirect_to developers_component_path(@component), notice: "Component created successfully."
    else
      @categories = Category.all.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all.ordered
  end

  def update
    if @component.update(component_params)
      redirect_to developers_component_path(@component), notice: "Component updated successfully."
    else
      @categories = Category.all.ordered
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @component.destroy
    redirect_to developers_components_path, notice: "Component deleted successfully."
  end

  private

  def set_component
    @component = current_user.components.find(params[:id])
  end

  def component_params
    params.require(:component).permit(
      :name, :tagline, :description, :readme, :repository_url,
      :documentation_url, :category_id, :license_type, :commercial_price_cents
    )
  end
end
