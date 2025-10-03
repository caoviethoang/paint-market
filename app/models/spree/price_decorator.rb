# app/models/spree/price_decorator.rb
module Spree
  module PriceDecorator
    MAXIMUM_AMOUNT = BigDecimal('500_000_000.00')

    def self.prepended(base)
      # Xóa validator cũ
      base._validators[:amount].delete_if do |v|
        v.is_a?(ActiveModel::Validations::NumericalityValidator)
      end

      # Xóa callbacks cũ
      base._validate_callbacks.each do |callback|
        if callback.filter.is_a?(ActiveModel::Validations::NumericalityValidator) &&
           callback.filter.attributes.include?(:amount)
          base._validate_callbacks.delete(callback)
        end
      end

      # Gắn validator mới
      base.validates :amount,
                     numericality: {
                       greater_than_or_equal_to: 0,
                       less_than_or_equal_to: MAXIMUM_AMOUNT
                     }
    end
  end
end

::Spree::Price.prepend Spree::PriceDecorator
