# app/controllers/solidus_admin/product_properties_controller.rb
module SolidusAdmin
  class ProductPropertiesController < SolidusAdmin::BaseController
    before_action :load_product

    def index
      @properties = Spree::Property.all

      # đảm bảo mỗi property có 1 product_property tương ứng
      @properties.each do |prop|
        @product.product_properties.find_or_initialize_by(property: prop)
      end

      render layout: "solidus_admin/application"
    end

    def update
      dsads
      if @product.update(product_params)
        flash[:success] = "Product properties updated successfully"
        redirect_to solidus_admin.product_path(@product)
      else
        flash[:error] = "Error updating product properties: #{@product.errors.full_messages.join(', ')}"
        @properties = Spree::Property.all
        render :index, layout: "solidus_admin/application"
      end
    end

    private

    def load_product
      @product = Spree::Product.friendly.find(params[:product_id])
    end

    def product_params
      params.require(:product).permit(
        product_properties_attributes: [ :id, :property_name, :value, :_destroy ]
      )
    end
  end
end
