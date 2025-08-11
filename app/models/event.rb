# app/models/event.rb
class Event < Spree::Base
  attr_accessor :remove_image_ids
  has_many_attached :images

  has_many :products, class_name: 'Spree::Product', dependent: :nullify
  
  # Validations
  validates :title, :description, :youtube_url, presence: true

  # Scopes for admin
  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[title description youtube_url created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[images_attachments images_blobs]
  end

  def image_urls(variant = :medium)
    return [] unless images.attached?

    images.map do |img|
      case variant
      when :thumb
        img.variant(resize_to_fill: [320, 180]).processed
      when :medium
        img.variant(resize_to_fill: [640, 360]).processed
      when :large
        img.variant(resize_to_fill: [1280, 720]).processed
      else
        img
      end
    end
  end

  def has_images?
    images.attached? && images.any?
  end

  # S3 URL với CDN support
  def display_image_urls(variant = :medium)
    if has_images?
      if Rails.application.config.active_storage.service.in?([:amazon_production, :amazon_development])
        image_urls(variant).map(&:url)
      else
        image_urls(variant).map do |img|
          Rails.application.routes.url_helpers.rails_blob_path(img, only_path: true)
        end
      end
    elsif youtube_url.present?
      [youtube_thumbnail_url]
    else
      []
    end
  end

  private

  def youtube_thumbnail_url(quality = 'hqdefault')
    video_id = extract_youtube_id(youtube_url)
    return nil if video_id.blank?

    "https://img.youtube.com/vi/#{video_id}/#{quality}.jpg"
  end

  def extract_youtube_id(url)
    return '' if url.blank?

    patterns = [
      /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/i,
      /^([a-zA-Z0-9_-]{11})$/
    ]
    patterns.each do |pattern|
      match = url.match(pattern)
      return match[1] if match
    end
    ''
  end
end
