module Spree
  module Admin
    class ArtistsController < ResourceController
      before_action :load_data, except: [ :index, :destroy ]

      def destroy
        @artist = Artist.find(params[:id])
        
        # Lưu số lượng products trước khi xóa để hiển thị thông báo
        products_count = @artist.products_count
        
        if @artist.destroy
          if products_count > 0
            flash[:warning] = "Artist '#{@artist.name}' has been deleted. #{products_count} associated products have been unassigned."
          else
            flash[:success] = "Artist '#{@artist.name}' has been successfully deleted."
          end
        else
          flash[:error] = "Unable to delete artist: #{@artist.errors.full_messages.join(', ')}"
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
        [ :name, :introduction, :start_work, :address, :background_image ]
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
