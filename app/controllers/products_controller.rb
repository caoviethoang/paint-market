# frozen_string_literal: true

class ProductsController < StoreController
  before_action :load_product, only: :show
  before_action :load_taxon, only: :index
  before_action :load_artist, only: :show
  before_action :load_taxonomies, only: :index

  helper "spree/products", "spree/taxons", "taxon_filters"

  respond_to :html

  rescue_from Spree::Config.searcher_class::InvalidOptions do |error|
    raise ActionController::BadRequest.new, error.message
  end

  def index
    @searcher = build_searcher(params.merge(include_images: true))
    products = @searcher.retrieve_products

    products = apply_property_filters(products, params[:search]) if params[:search].present?
    products = apply_price_filter(products, params[:search][:price_range_any]) if params[:search][:price_range_any].present?

    # Add distinct and paginate manually
    @products = products.distinct.page(params[:page]).per(12)
  end

  def show
    @variants = @product.
      variants_including_master.
      display_includes.
      with_prices(current_pricing_options).
      includes([ :option_values, :images ])

    @product_properties = @product.product_properties.includes(:property)
    @taxon = Spree::Taxon.find(params[:taxon_id]) if params[:taxon_id]
    @similar_products = @artist.products.where.not(id: @product.id).limit(3)
  end

  private

  def accurate_title
    if @product
      @product.meta_title.blank? ? @product.name : @product.meta_title
    else
      super
    end
  end

  def load_product
    if spree_current_user.try(:has_spree_role?, "admin")
      @products = Spree::Product.with_discarded
    else
      @products = Spree::Product.available
    end
    @product = @products.friendly.find(params[:id])

    # Redirects to the correct product URL if the requested slug does not match the current product's slug.
    # This ensures that outdated or ID URLs always resolve to the latest canonical URL.
    redirect_to @product, status: :moved_permanently if params[:id] != @product.slug
  end

  def load_taxon
    @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
  end

  def load_artist
    @artist = Artist.find(@product.artist_id)
  end

  def load_taxonomies
    @taxonomies = Spree::Taxonomy.includes(:taxons).all
  end

  # Applies filters coming from dynamic property checkboxes built in TaxonFiltersHelper
  # Expected param shape: params[:search]["<property_name>_any"] = ["value1", "value2"]
  def apply_property_filters(products_relation, search_params)
    filtered = products_relation

    search_params.each do |scope_key, selected_values|
      next if selected_values.blank?

      # Only handle dynamic "*_any" scopes created from property names
      scope_str = scope_key.to_s
      next unless scope_str.end_with?("_any")

      property_key = scope_str.sub(/_any\z/, "")
      # Properties are stored with names that parameterize to snake_case keys used as scopes
      property = Spree::Property.find_by(name: property_key) || Spree::Property.find_by("LOWER(name) = ?", property_key)
      next unless property

      # Ensure array of values
      values = Array(selected_values).map(&:to_s).reject(&:blank?)
      next if values.empty?

      filtered = filtered.joins(:product_properties).where(
        spree_product_properties: {
          property_id: property.id,
          value: values
        }
      )
    end

    filtered.distinct
  end

  def apply_price_filter(products_relation, selected_ranges)
    filtered = products_relation
    values = Array(selected_ranges).map(&:to_s).reject(&:blank?)

    values.each do |range|
      case range
      when "under_10m"
        filtered = filtered.joins(master: :prices).where("spree_prices.amount < ?", 10_000_000)
      when "10m_to_50m"
        filtered = filtered.joins(master: :prices).where("spree_prices.amount >= ? AND spree_prices.amount < ?", 10_000_000, 50_000_000)
      when "50m_to_100m"
        filtered = filtered.joins(master: :prices).where("spree_prices.amount >= ? AND spree_prices.amount < ?", 50_000_000, 100_000_000)
      when "over_100m"
        filtered = filtered.joins(master: :prices).where("spree_prices.amount >= ?", 100_000_000)
      end
    end

    filtered.distinct
  end
end
