module Spree
  module Admin
    class TaxonomiesController < ResourceController
      before_action :load_data, except: [:index, :destroy]

      private

      def collection
        return @collection if @collection

        params[:q] ||= {}
        params[:q][:s] ||= "name asc"

        @search = super.ransack(params[:q])
        @collection = @search.result.page(params[:page])
                             .per(params[:per_page] || Spree::Config[:admin_products_per_page])
      end

      def permitted_resource_params
        params.require(:taxonomy).permit(permitted_taxonomy_attributes)
      end

      def permitted_taxonomy_attributes
        [:name, :description]
      end

      def load_data
        @taxonomy = @object if @object
      end

      def model_class
        Spree::Taxonomy
      end

      def object_name
        "taxonomy"
      end
    end
  end
end 