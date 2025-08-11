module Spree
  module Admin
    class EventsController < ResourceController
      before_action :load_data, except: [:index, :destroy]
      private

      def collection
        return @collection if @collection

        params[:q] ||= {}
        params[:q][:s] ||= 'created_at desc'

        @search = super.ransack(params[:q])
        @collection = @search.result.includes(:images_attachments)
                             .page(params[:page])
                             .per(params[:per_page] || Spree::Config[:admin_products_per_page])
      end

      def permitted_resource_params
        params.require(:event).permit(permitted_event_attributes)
      end

      def permitted_event_attributes
        [:title, :description, :youtube_url, images: []]
      end

      def load_data
        @event = @object if @object
      end

      def model_class
        Event
      end

      def object_name
        'event'
      end
    end
  end
end
