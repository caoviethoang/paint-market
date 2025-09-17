# frozen_string_literal: true

require 'spree/core/product_filters'

module TaxonFiltersHelper
  def applicable_filters_for(_taxon)
    # Only include price filter as base filter
    base_filters = [
      :price_filter
    ]

    # Add dynamic property filters from database
    dynamic_filters = properties_with_values.map do |property|
      create_property_filter(property)
    end

    # Combine base and dynamic filters
    all_filters = base_filters + dynamic_filters

    all_filters.map do |filter_name|
      case filter_name
      when :price_filter
        custom_price_filter
      else
        filter_name # This will be a hash for dynamic filters
      end
    end.compact
  end

  private

  def properties_with_values
    @properties_with_values ||= Spree::Property.joins("INNER JOIN property_values ON property_values.property_id = spree_properties.id").distinct
  end

  def create_property_filter(property)
    # Get property values ordered by position and display_name
    property_values = PropertyValue.where(property: property).order(:position, :display_name)

    {
      name: I18n.t("spree.filters.#{property.name}", default: property.presentation || property.name),
      scope: "#{property.name.parameterize.underscore}_any".to_sym,
      labels: property_values.map { |value|
        [
          I18n.t("spree.filters.#{value.value}", default: value.display_name),
          value.value
        ]
      },
      conds: property_values.map do |value|
        [value.value, ->(products) {
          products.joins(:product_properties).where(
            spree_product_properties: {
              property_id: property.id,
              value: value.value
            }
          )
        }]
      end
    }
  end

  def orientation_filter
    {
      name: I18n.t('spree.filters.orientation'),
      scope: :orientation_any,
      labels: [
        [I18n.t('spree.filters.vertical'), 'vertical'],
        [I18n.t('spree.filters.horizontal'), 'horizontal'],
        [I18n.t('spree.filters.square'), 'square']
      ],
      conds: [
        ['vertical', ->(products) { products.joins(:product_properties).where(spree_product_properties: { property_id: orientation_property_id, value: 'vertical' }) }],
        ['horizontal', ->(products) { products.joins(:product_properties).where(spree_product_properties: { property_id: orientation_property_id, value: 'horizontal' }) }],
        ['square', ->(products) { products.joins(:product_properties).where(spree_product_properties: { property_id: orientation_property_id, value: 'square' }) }]
      ]
    }
  end

  def material_filter
    {
      name: I18n.t('spree.filters.material'),
      scope: :material_any,
      labels: material_labels,
      conds: material_conditions
    }
  end

  def style_filter
    {
      name: I18n.t('spree.filters.style'),
      scope: :style_any,
      labels: style_labels,
      conds: style_conditions
    }
  end

  def material_labels
    [
      [I18n.t('spree.filters.oil_paint'), 'oil'],
      [I18n.t('spree.filters.acrylic'), 'acrylic'],
      [I18n.t('spree.filters.watercolor'), 'watercolor'],
      [I18n.t('spree.filters.canvas'), 'canvas'],
      [I18n.t('spree.filters.paper'), 'paper'],
      [I18n.t('spree.filters.wood'), 'wood']
    ]
  end

  def material_conditions
    material_labels.map do |label, value|
      [value, ->(products) { products.joins(:product_properties).where(spree_product_properties: { property_id: material_property_id, value: value }) }]
    end
  end

  def style_labels
    [
      [I18n.t('spree.filters.abstract'), 'abstract'],
      [I18n.t('spree.filters.realism'), 'realism'],
      [I18n.t('spree.filters.impressionism'), 'impressionism'],
      [I18n.t('spree.filters.expressionism'), 'expressionism'],
      [I18n.t('spree.filters.contemporary'), 'contemporary'],
      [I18n.t('spree.filters.classical'), 'classical']
    ]
  end

  def style_conditions
    style_labels.map do |label, value|
      [value, ->(products) { products.joins(:product_properties).where(spree_product_properties: { property_id: style_property_id, value: value }) }]
    end
  end

  def orientation_property_id
    @orientation_property_id ||= Spree::Property.find_by(name: 'orientation')&.id
  end



  def material_property_id
    @material_property_id ||= Spree::Property.find_by(name: 'material')&.id
  end

  def style_property_id
    @style_property_id ||= Spree::Property.find_by(name: 'style')&.id
  end

  def custom_price_filter
    {
      name: I18n.t('spree.filters.price'),
      scope: :price_range_any,
      labels: [
        [I18n.t('spree.filters.under_10m'), 'under_10m'],
        [I18n.t('spree.filters.10m_to_15m'), '10m_to_15m'],
        [I18n.t('spree.filters.15m_to_30m'), '15m_to_30m'],
        [I18n.t('spree.filters.over_30m'), 'over_30m']
      ],
      conds: [
        ['under_10m', ->(products) { products.joins(:master => :prices).where('spree_prices.amount < ?', 10_000_000) }],
        ['10m_to_15m', ->(products) { products.joins(:master => :prices).where('spree_prices.amount >= ? AND spree_prices.amount < ?', 10_000_000, 15_000_000) }],
        ['15m_to_30m', ->(products) { products.joins(:master => :prices).where('spree_prices.amount >= ? AND spree_prices.amount < ?', 15_000_000, 30_000_000) }],
        ['over_30m', ->(products) { products.joins(:master => :prices).where('spree_prices.amount >= ?', 30_000_000) }]
      ]
    }
  end
end
