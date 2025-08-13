module Spree
  module ProductDecorator
    def self.prepended(base)
      base.belongs_to :event, optional: true
      base.belongs_to :artist
    end
  end
end

Spree::Product.prepend Spree::ProductDecorator
