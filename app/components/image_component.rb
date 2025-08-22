# frozen_string_literal: true

class ImageComponent < ViewComponent::Base
  attr_reader :image, :size, :classes, :options

  def initialize(local_assigns = {})
    @image = local_assigns.delete(:image)
    @size = local_assigns.delete(:size) { :mini }
    @classes = local_assigns.delete(:classes)
    @options = local_assigns
  end

  def call
    url = image_url
    if image_present? && url.present?
      image_tag url, default_options.merge(options)
    else
      content_tag :div, nil, class: ['image-placeholder', size].join(' ')
    end
  end

  private

  def image_present?
    return false unless image
    
    begin
      if image.respond_to?(:attached?)
        # Active Storage
        image.attached?
      elsif image.respond_to?(:attachment)
        # Spree::Image với Active Storage attachment
        image.attachment&.attached?
      elsif image.respond_to?(:url) && !image.respond_to?(:attached?)
        # Spree::Image cũ (không dùng Active Storage)
        true
      else
        false
      end
    rescue => e
      Rails.logger.warn "Error checking image presence: #{e.message}"
      false
    end
  end

  def image_url
    return nil unless image
    
    begin
      if image.respond_to?(:attached?) && image.attached?
        # Active Storage
        image.url(size)
      elsif image.respond_to?(:attachment) && image.attachment&.attached?
        # Spree::Image với Active Storage attachment
        image.attachment.url(size)
      elsif image.respond_to?(:url) && !image.respond_to?(:attached?)
        # Spree::Image cũ (không dùng Active Storage)
        image.url
      else
        nil
      end
    rescue => e
      Rails.logger.warn "Error getting image URL: #{e.message}"
      nil
    end
  end

  def default_options
    if image_present?
      alt_text = if image.respond_to?(:alt)
                   image.alt
                 elsif image.respond_to?(:name)
                   image.name
                 else
                   "Image"
                 end
      { alt: alt_text, class: classes }
    else
      { class: classes }
    end
  end
end
