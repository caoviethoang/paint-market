# frozen_string_literal: true

include ApplicationHelper
class DiscoveryCardComponent < ViewComponent::Base
  def initialize(product)
    @product = product
  end

  attr_reader :product

  def main_image
    return nil unless product.gallery&.images&.any?
    product.gallery.images.first
  end

  def display_price
    product.master&.default_price&.money
  end

  def price_currency
    Spree::Config[:currency]
  end
end
