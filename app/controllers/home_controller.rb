# frozen_string_literal: true

class HomeController < StoreController
  helper "spree/products"
  respond_to :html

  def index
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxon.all
    @example_taxonomies = get_example_taxonomies(5)
    @event = Event.active.first

    products = Spree::Product.all
    total = products.size
    @newest = products.last(5)
    @outstanding = products.first(5)
    @overatting = products.left_joins(:votes)
                  .group('spree_products.id')
                  .select('spree_products.*, AVG(votes.star) as avg_rating, COUNT(votes.id) as votes_count')
                  .order('avg_rating DESC NULLS LAST, votes_count DESC')
                  .limit(5) || products[[total - 15, 0].max, 5]
    @care = products.order(views_count: :desc).limit(5) || products[[total - 10, 0].max, 5]
  end

  private

  def get_example_taxonomies(limit = 5)
    all_taxonomies = Spree::Taxonomy.includes(root: { children: :products }).all.reorder(Arel.sql('LENGTH(name) ASC'))
    return nil if all_taxonomies.empty?

    taxonomy_data = []

    all_taxonomies.each do |taxonomy|
      break if taxonomy_data.length >= limit

      next unless taxonomy.root.present?

      product_with_image = nil
      image = nil

      taxonomy.root.products.each do |product|
        if product.respond_to?(:gallery) && product.gallery.present? && product.gallery.respond_to?(:images)
          if product.gallery.images.any?
            product_with_image = product
            image = product.gallery.images.first
            break
          end
        elsif product.respond_to?(:images) && product.images.any?
          product_with_image = product
          image = product.images.first
          break
        elsif product.respond_to?(:attachments) && product.attachments.any?
          product_with_image = product
          image = product.attachments.first
          break
        end
      end

      if product_with_image.nil?
        product_with_image = taxonomy.root.products.first
      end

      next unless product_with_image.present?

      if image.present?
        taxonomy_data << {
          taxonomy: taxonomy,
          product: product_with_image,
          image: image
        }
      else
        taxonomy_data << {
          taxonomy: taxonomy,
          product: product_with_image,
          image: nil
        }
      end
    end

    while taxonomy_data.length < limit && all_taxonomies.length > 0
      taxonomy = all_taxonomies[taxonomy_data.length % all_taxonomies.length]
      next unless taxonomy.root.present?

      taxonomy_data << {
        taxonomy: taxonomy,
        product: taxonomy.root.products.first,
        image: nil
      }
    end

    taxonomy_data
  end
end
