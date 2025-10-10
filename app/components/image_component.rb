# app/components/image_component.rb
class ImageComponent < ViewComponent::Base
  attr_reader :image, :size, :classes, :options

  def initialize(local_assigns = {})
    @image = local_assigns.delete(:image)
    @size = local_assigns.delete(:size) { :mini }
    @classes = local_assigns.delete(:class) || local_assigns.delete(:classes)
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
      if image.respond_to?(:attachment)
        image.attachment&.attached?
      elsif image.respond_to?(:attached?)
        image.attached?
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
      # Spree::Image với Active Storage attachment
      if image.respond_to?(:attachment) && image.attachment&.attached?
        blob = image.attachment.blob
        generate_s3_url(blob)

      # Active Storage blob trực tiếp
      elsif image.respond_to?(:blob)
        blob = image.blob
        generate_s3_url(blob)

      else
        nil
      end
    rescue => e
      Rails.logger.error "Error getting image URL: #{e.message}"
      Rails.logger.error e.backtrace.first(5).join("\n")
      nil
    end
  end

  def generate_s3_url(blob)
    bucket = blob.service.bucket
    object = bucket.object(blob.key)

    object.presigned_url(
      :get,
      expires_in: 7.days.to_i,
      response_content_disposition: "inline; filename=\"#{blob.filename}\""
    )
  rescue => e
    Rails.logger.error "Error generating S3 URL: #{e.message}"
    blob.url rescue nil
  end

  def default_options
    alt_text = if image.respond_to?(:alt) && image.alt.present?
                 image.alt
               elsif image.respond_to?(:name) && image.name.present?
                 image.name
               elsif image.respond_to?(:attachment) && image.attachment&.blob
                 image.attachment.blob.filename.to_s
               elsif image.respond_to?(:filename)
                 image.filename.to_s
               else
                 "Product image"
               end
    { alt: alt_text, class: classes }
  end
end
