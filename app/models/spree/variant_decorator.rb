module Spree
  module VariantDecorator
    def self.prepended(base)
      base._validators[:cost_price]&.clear
    end
  end
end

::Spree::Variant.prepend Spree::VariantDecorator
