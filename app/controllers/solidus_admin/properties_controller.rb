# frozen_string_literal: true

module SolidusAdmin
  class PropertiesController < SolidusAdmin::ResourcesController
    def index
      @search = resources_collection.ransack(params[:q])
      @collection = @search.result.page(params[:page]).per(params[:per_page] || 25)

      render layout: "solidus_admin/application"
    end

    def edit
      @property = Spree::Property.find(params[:id])
      render layout: "solidus_admin/application"
    end

    def values
      property = Spree::Property.find(params[:id])
      render json: property.property_values.ordered.as_json(only: [ :id, :value, :display_name ])
    end

    private

    def resource_class = Spree::Property

    def permitted_resource_params
      params.require(:property).permit(:name, :presentation)
    end

    def resources_collection = Spree::Property.unscoped
  end
end
