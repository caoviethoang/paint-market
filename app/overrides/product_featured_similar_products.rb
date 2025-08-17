# frozen_string_literal: true

module ProductFeaturedSimilarProducts
  Deface::Override.new(
    virtual_path: "spree/products/show",
    name: "product_featured_similar_products",
    insert_after: "[data-hook='product_properties']",
    text: "<%= render 'spree/products/featured_similar_products', product: @product %>"
  )

  def self.prepended(base)
    base.scope :featured, -> { where(featured: true) }
  end

  def similar_products(limit = 3)
    taxons.map do |taxon|
      taxon.all_products_except(self.id)
    end.flatten.uniq.first(limit)
  end

  Spree::Product.prepend self
end
