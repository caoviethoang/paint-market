# app/models/event.rb
class Artist < Spree::Base
  has_one_attached :background_image

  has_many :products, class_name: "Spree::Product", dependent: :nullify

  # Validations
  validates :name, :introduction, :dob, :address, presence: true
  validate :background_image_presence

  # Scopes for admin
  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[name introduction dob address created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[background_image_attachment background_image_blob]
  end

  # def image_urls(variant = :medium)
  #   return [] unless images.attached?

  #   images.map do |img|
  #     case variant
  #     when :thumb
  #       img.variant(resize_to_fill: [ 320, 180 ]).processed
  #     when :medium
  #       img.variant(resize_to_fill: [ 640, 360 ]).processed
  #     when :large
  #       img.variant(resize_to_fill: [ 1280, 720 ]).processed
  #     else
  #       img
  #     end
  #   end
  # end

  # def has_images?
  #   images.attached? && images.any?
  # end

  # S3 URL với CDN support
  def display_image_urls(variant = :medium)
    return [] unless has_images?

    images.filter_map do |img|
      # Bỏ qua ảnh không tồn tại trên storage
      next unless img.blob&.service.exist?(img.blob.key)

      case variant
      when :thumb
        img.variant(resize_to_fill: [ 320, 180 ]).processed
      when :medium
        img.variant(resize_to_fill: [ 640, 360 ]).processed
      when :large
        img.variant(resize_to_fill: [ 1280, 720 ]).processed
      else
        img
      end
    end.map do |processed_image|
      if Rails.application.config.active_storage.service.in?([ :amazon_production, :amazon_development ])
        processed_image.url
      else
        Rails.application.routes.url_helpers.rails_blob_path(processed_image, only_path: true)
      end
    end
  end

  private

  def background_image_presence
    errors.add(:background_image, "must be attached") unless background_image.attached?
  end
end
