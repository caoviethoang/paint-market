# frozen_string_literal: true

class HomeController < StoreController
  helper 'spree/products'
  respond_to :html

  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(:root)
    @recent_images = get_recent_images(7)
    @example_taxonomies = get_example_taxonomies(3)

    # Split products into groups of 3 for the homepage blocks.
    # You probably want to remove this logic and use your own!
    homepage_groups = @products.in_groups_of(3, false)
    @featured_products = homepage_groups[0]
    @collection_products = homepage_groups[1]
    @cta_collection_products = homepage_groups[2]
    @new_arrivals = homepage_groups[3]
  end

  private

  def get_recent_images(limit = 6)
    images = []

    begin
      # Get recent products that have images in their gallery
      products_with_images = Spree::Product.includes(gallery: :images)
                                        .joins(:gallery)
                                        .joins('JOIN spree_images ON spree_images.gallery_id = spree_galleries.id')
                                        .order('spree_products.created_at DESC')
                                        .limit(limit * 2)
                                        .distinct

      Rails.logger.info "Found #{products_with_images.count} products with images"

      products_with_images.each do |product|
        break if images.length >= limit

        Rails.logger.info "Processing product: #{product.name}, gallery present: #{product.gallery.present?}, images count: #{product.gallery&.images&.count || 0}"

        if product.gallery.present? && product.gallery.images.any?
          # Get the first image from this product
          image = product.gallery.images.first
          if image.present?
            Rails.logger.info "Adding image for product: #{product.name}"
            images << {
              attachment: image,
              source: product,
              type: 'Product'
            }
          end
        end
      end

      Rails.logger.info "Total images collected: #{images.length}"

    rescue => e
      Rails.logger.warn "Error loading product images: #{e.message}"
      Rails.logger.warn e.backtrace.join("\n")

      # Fallback: try to get any products with images
      begin
        fallback_products = Spree::Product.includes(gallery: :images).limit(limit)
        fallback_products.each do |product|
          break if images.length >= limit

          if product.gallery.present? && product.gallery.images.any?
            image = product.gallery.images.first
            if image.present?
              images << {
                attachment: image,
                source: product,
                type: 'Product'
              }
            end
          end
        end
        Rails.logger.info "Fallback collected #{images.length} images"
      rescue => fallback_error
        Rails.logger.warn "Fallback also failed: #{fallback_error.message}"
      end
    end

    # If we don't have enough images, create some dummy ones
    while images.length < limit
      dummy_image = {
        attachment: nil,
        source: { title: "Sample Product #{images.length + 1}", name: "Sample #{images.length + 1}" },
        type: 'Product',
        is_dummy: true
      }
      images << dummy_image
    end

    Rails.logger.info "Final images count: #{images.length}"
    Rails.logger.info "Returning images: #{images.inspect}"
    images.first(limit)
  end

  def get_example_taxonomies(limit = 3)
    taxonomies = Spree::Taxonomy.includes(root: { children: { products: { gallery: :images } } }).first(limit)

    # Return nil if no taxonomies exist
    return nil if taxonomies.empty?

    taxonomy_data = taxonomies.map do |taxonomy|
      next unless taxonomy.root.present?

      # Get first 1 product from this taxonomy
      product = taxonomy.root.products.first
      next unless product.present?

      # Get first 1 image from this product
      image = nil
      if product.gallery.present? && product.gallery.images.any?
        image = product.gallery.images.first
      end

      # Skip if no image available
      next unless image.present?

      {
        taxonomy: taxonomy,
        product: product,
        image: image
      }
    end.compact

    # Return nil if no valid taxonomy data
    return nil if taxonomy_data.empty?

    taxonomy_data
  end
end
