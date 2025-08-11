module Spree
  module ProductDecorator
    def self.prepended(base)
      base.belongs_to :event, optional: true
    end
  end
end

Spree::Product.prepend Spree::ProductDecorator