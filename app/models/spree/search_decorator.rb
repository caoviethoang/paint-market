# frozen_string_literal: true

module Spree
  module SearchDecorator
    def self.prepended(base)
      base.class_eval do
        def initialize(params = {})
          super()
          @properties = params[:search] || {}
        end

        def retrieve_products
          @products = base_scope
          curr_page = page || 1

          # Apply base filters (price only)
          unless @properties[:price_range_any].blank?
            @products = apply_price_filters(@products)
          end

          # Apply dynamic property filters
          apply_dynamic_property_filters

          @products = @products.page(curr_page).per(per_page)
        end

        private

        def apply_dynamic_property_filters
          # Get all properties with values from database
          Spree::Property.joins("INNER JOIN property_values ON property_values.property_id = spree_properties.id").distinct.each do |property|
            filter_key = "#{property.name.parameterize.underscore}_any".to_sym
            values = @properties[filter_key]
            
            unless values.blank?
              @products = @products.joins(:product_properties)
                                  .where(spree_product_properties: { 
                                    property_id: property.id, 
                                    value: values 
                                  })
            end
          end
        end

        def apply_price_filters(products)
          price_ranges = @properties[:price_range_any]
          return products if price_ranges.blank?

          conditions = []
          price_ranges.each do |range|
            case range
            when 'under_10m'
              conditions << "spree_prices.amount < 10000000"
            when '10m_to_15m'
              conditions << "spree_prices.amount >= 10000000 AND spree_prices.amount < 15000000"
            when '15m_to_30m'
              conditions << "spree_prices.amount >= 15000000 AND spree_prices.amount < 30000000"
            when 'over_30m'
              conditions << "spree_prices.amount >= 30000000"
            end
          end

          if conditions.any?
            products.joins(:master => :prices).where(conditions.join(' OR '))
          else
            products
          end
        end


      end
    end
  end
end

Spree::Config.searcher_class.prepend(Spree::SearchDecorator)
