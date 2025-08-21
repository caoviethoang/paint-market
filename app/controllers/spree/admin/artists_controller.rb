module Spree
  module Admin
    class ArtistsController < ResourceController
      before_action :load_data, except: [ :index, :destroy ]

      def destroy
        @artist = Artist.find(params[:id])
        
        if @artist.can_be_destroyed?
          @artist.destroy
          flash[:success] = "Artist '#{@artist.name}' has been successfully deleted."
        else
          # Nếu có products, hiển thị warning và xóa
          @artist.destroy_with_products
          flash[:warning] = "Artist '#{@artist.name}' has been deleted. All associated products have been unassigned."
        end
        
        respond_with(@artist) do |format|
          format.html { redirect_to admin_artists_path }
          format.js { render :destroy }
        end
      rescue => e
        flash[:error] = "Error deleting artist: #{e.message}"
        respond_with(@artist) do |format|
          format.html { redirect_to admin_artists_path }
          format.js { render :destroy }
        end
      end

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
