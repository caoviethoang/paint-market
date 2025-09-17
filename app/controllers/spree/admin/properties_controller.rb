# frozen_string_literal: true

module Spree
  module Admin
    class PropertiesController < ResourceController
      before_action :load_property, only: [:show, :edit, :update, :destroy, :values]

      def values
        @values = PropertyValue.where(property: @property).order(:position, :display_name)

        respond_to do |format|
          format.json { render json: { values: @values.map { |v| { value: v.value, display_name: v.display_name } } } }
        end
      end

      private

      def collection
        return @collection if @collection

        params[:q] ||= {}
        params[:q][:s] ||= "name asc"

        @search = super.ransack(params[:q])
        @collection = @search.result
      end

      def model_class
        Spree::Property
      end

      def load_property
        @property = Spree::Property.find(params[:id])
      end

      def permitted_resource_params
        params.require(:property).permit(:name, :presentation,
                                        property_values_attributes: [:id, :value, :display_name, :position, :_destroy])
      end
    end
  end
end
