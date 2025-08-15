module Spree
  module Admin
    class ArtistsController < ResourceController
      before_action :load_data, except: [ :index, :destroy ]
      private

      def collection
        return @collection if @collection

        params[:q] ||= {}
        params[:q][:s] ||= "created_at desc"

        @search = super.ransack(params[:q])
        @collection = @search.result.page(params[:page])
                             .per(params[:per_page] || Spree::Config[:admin_products_per_page])
      end

      def permitted_resource_params
        params.require(:artist).permit(permitted_artist_attributes)
      end

      def permitted_artist_attributes
        [ :name, :introduction, :dob, :address, :background_image ]
      end

      def load_data
        @artist = @object if @object
      end

      def model_class
        Artist
      end

      def object_name
        "artist"
      end
    end
  end
end
