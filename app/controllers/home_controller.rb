# frozen_string_literal: true

class HomeController < StoreController
  helper "spree/products"
  respond_to :html

  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxon.all
    @recent_images = get_recent_images(7)
    @example_taxonomies = get_example_taxonomies(5)

    # Split products into groups of 3 for the homepage blocks.
    # You probably want to remove this logic and use your own!
    homepage_groups = @products.in_groups_of(3, false)
    @featured_products = homepage_groups[0]
    @collection_products = homepage_groups[1]
    @cta_collection_products = homepage_groups[2]
    @new_arrivals = @products.last(5)

    @event = Event.active.first
  end

  private

  def get_recent_images(limit = 6)
    images = []

    begin
      # Get recent products that have images in their gallery
      products_with_images = Spree::Product.includes(gallery: :images)
                                        .joins(:gallery)
                                        .joins("JOIN spree_images ON spree_images.gallery_id = spree_galleries.id")
                                        .order("spree_products.created_at DESC")
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
              type: "Product"
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
                type: "Product"
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
        type: "Product",
        is_dummy: true
      }
      images << dummy_image
    end

    Rails.logger.info "Final images count: #{images.length}"
    Rails.logger.info "Returning images: #{images.inspect}"
    images.first(limit)
  end

  def get_example_taxonomies(limit = 3)
    # Get all available taxonomies with products
    all_taxonomies = Spree::Taxonomy.includes(root: { children: :products }).all

    Rails.logger.info "Found #{all_taxonomies.length} total taxonomies"

    # Return nil if no taxonomies exist
    return nil if all_taxonomies.empty?

    taxonomy_data = []

    all_taxonomies.each do |taxonomy|
      break if taxonomy_data.length >= limit

      Rails.logger.info "Processing taxonomy: #{taxonomy.name}"
      next unless taxonomy.root.present?

      # Try to find a product with images in this taxonomy
      product_with_image = nil
      image = nil

      # First, try to find any product with images through gallery
      Rails.logger.info "Checking #{taxonomy.root.products.count} products in taxonomy: #{taxonomy.name}"
      taxonomy.root.products.each do |product|
        Rails.logger.info "Product: #{product.name}"

        # Try different ways to get images
        if product.respond_to?(:gallery) && product.gallery.present? && product.gallery.respond_to?(:images)
          if product.gallery.images.any?
            product_with_image = product
            image = product.gallery.images.first
            Rails.logger.info "Found product with gallery image: #{product.name} for taxonomy: #{taxonomy.name}"
            break
          end
        elsif product.respond_to?(:images) && product.images.any?
          product_with_image = product
          image = product.images.first
          Rails.logger.info "Found product with direct image: #{product.name} for taxonomy: #{taxonomy.name}"
          break
        elsif product.respond_to?(:attachments) && product.attachments.any?
          product_with_image = product
          image = product.attachments.first
          Rails.logger.info "Found product with attachment: #{product.name} for taxonomy: #{taxonomy.name}"
          break
        end
      end

      # If no product with image found, get the first product
      if product_with_image.nil?
        product_with_image = taxonomy.root.products.first
        Rails.logger.info "No product with image found, using first product: #{product_with_image&.name || 'none'}"
      end

      next unless product_with_image.present?

      # Create entry
      if image.present?
        Rails.logger.info "Adding taxonomy with image: #{taxonomy.name}"
        taxonomy_data << {
          taxonomy: taxonomy,
          product: product_with_image,
          image: image
        }
      else
        Rails.logger.info "Creating fallback entry without image for: #{taxonomy.name}"
        taxonomy_data << {
          taxonomy: taxonomy,
          product: product_with_image,
          image: nil
        }
      end
    end

    # If we don't have enough taxonomies, create additional fallback data
    while taxonomy_data.length < limit && all_taxonomies.length > 0
      taxonomy = all_taxonomies[taxonomy_data.length % all_taxonomies.length]
      next unless taxonomy.root.present?

      Rails.logger.info "Creating additional fallback entry for: #{taxonomy.name}"
      # Create fallback entry
      taxonomy_data << {
        taxonomy: taxonomy,
        product: taxonomy.root.products.first,
        image: nil # Will be handled in view
      }
    end

    Rails.logger.info "Final taxonomy_data count: #{taxonomy_data.length}"
    Rails.logger.info "Returning taxonomies: #{taxonomy_data.map { |td| td[:taxonomy].name }}"

    taxonomy_data
  end
end
