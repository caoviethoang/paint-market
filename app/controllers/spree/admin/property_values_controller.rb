# frozen_string_literal: true

module Spree
  module Admin
    class PropertyValuesController < ResourceController
      before_action :load_property
      before_action :load_property_value, only: [:edit, :update, :destroy]

      def index
        @property_values = PropertyValue.where(property: @property).order(:position, :display_name)
      end

      def new
        @property_value = PropertyValue.new(property: @property)
      end

      def create
        @property_value = PropertyValue.new(property_value_params)
        @property_value.property = @property
        
        if @property_value.save
          flash[:success] = "Property value created successfully"
          redirect_to admin_property_path(@property)
        else
          flash[:error] = "Error: #{@property_value.errors.full_messages.join(', ')}"
          redirect_to admin_property_path(@property)
        end
      end

      def update
        if @property_value.update(property_value_params)
          flash[:success] = "Property value updated successfully"
          redirect_to admin_property_path(@property)
        else
          flash[:error] = "Error: #{@property_value.errors.full_messages.join(', ')}"
          redirect_to admin_property_path(@property)
        end
      end

      def destroy
        if @property_value.destroy
          flash[:success] = "Property value deleted successfully"
        else
          flash[:error] = "Unable to delete property value"
        end
        
        redirect_to admin_property_path(@property)
      end

      private

      def load_property
        @property = Spree::Property.find(params[:property_id])
      end

      def load_property_value
        @property_value = PropertyValue.where(property: @property).find(params[:id])
      end

      def model_class
        PropertyValue
      end

      def property_value_params
        params.require(:property_value).permit(:value, :display_name, :position)
      end
    end
  end
end
