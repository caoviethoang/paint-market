# frozen_string_literal: true

module Spree
  module ProductPropertyDecorator
    def self.prepended(base)
      base.class_eval do
        belongs_to :property_value, class_name: 'PropertyValue', optional: true

        before_validation :sync_value_from_property_value
      end
    end

    private

    def sync_value_from_property_value
      self.value = property_value&.value if property_value.present?
    end
  end
end

Spree::ProductProperty.prepend Spree::ProductPropertyDecorator
