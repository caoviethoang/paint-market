# app/controllers/solidus_admin/product_properties_controller.rb
module SolidusAdmin
  class ProductPropertiesController < SolidusAdmin::BaseController
    before_action :load_product

    def index
      # load toàn bộ property đã có
      @properties = Spree::Property.all

      # đảm bảo mỗi property có 1 product_property tương ứng
      @properties.each do |prop|
        @product.product_properties.find_or_initialize_by(property: prop)
      end

      render layout: 'solidus_admin/application'
    end

    private

    def load_product
      @product = Spree::Product.friendly.find(params[:product_id])
    end
  end
end
