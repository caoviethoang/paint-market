module Spree
  module VariantDecorator
    def self.prepended(base)
      base._validators[:cost_price].delete_if do |v|
        v.is_a?(ActiveModel::Validations::NumericalityValidator)
      end

      base._validate_callbacks.each do |callback|
        if callback.filter.is_a?(ActiveModel::Validations::NumericalityValidator) &&
           callback.filter.attributes.include?(:cost_price)
          base._validate_callbacks.delete(callback)
        end
      end

      base.validates :cost_price,
                     numericality: {
                       greater_than_or_equal_to: 0,
                       less_than_or_equal_to: 500_000_000
                     },
                     allow_nil: true
    end
  end
end

::Spree::Variant.prepend Spree::VariantDecorator
