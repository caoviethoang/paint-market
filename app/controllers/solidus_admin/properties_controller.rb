# frozen_string_literal: true

module SolidusAdmin
  class PropertiesController < SolidusAdmin::ResourcesController
    def index
      # Load collection for search and pagination
      @search = resources_collection.ransack(params[:q])
      @collection = @search.result.page(params[:page]).per(params[:per_page] || 25)
      
      # Use SolidusAdmin layout but render custom content
      render layout: 'solidus_admin/application'
    end

    def edit
      @property = resource
      render layout: 'solidus_admin/application'
    end

    private

    def resource_class = Spree::Property

    def permitted_resource_params
      params.require(:property).permit(:name, :presentation)
    end

    def resources_collection = Spree::Property.unscoped
  end
end
