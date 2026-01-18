class ComponentsController < ApplicationController
  include Pagy::Backend

  def index
    @components = Component.published.includes(:developer, :category)

    if params[:category].present?
      @components = @components.joins(:category).where(categories: { slug: params[:category] })
    end

    if params[:search].present?
      @components = @components.where("name LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end

    @components = case params[:sort]
    when "popular"
      @components.popular
    when "recent"
      @components.recent
    else
      @components.order(featured: :desc, published_at: :desc)
    end

    @pagy, @components = pagy(@components, items: 12)
    @categories = Category.top_level.ordered
  end

  def show
    @component = Component.friendly.find(params[:slug])
    authorize @component

    @versions = @component.versions.published.recent
    @reviews = @component.reviews.includes(:user).recent.limit(5)
  end
end
