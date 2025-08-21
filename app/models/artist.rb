# app/models/artist.rb
class Artist < Spree::Base
  has_one_attached :background_image

  has_many :products, class_name: "Spree::Product", dependent: :nullify

  # Validations
  validates :name, :introduction, :dob, :address, presence: true
  validate :background_image_presence

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(auth_object = nil)
    %w[name introduction dob address created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[background_image_attachment background_image_blob]
  end

  # Kiểm tra xem artist có thể xóa được không
  def can_be_destroyed?
    products.empty?
  end

  # Xóa artist và xử lý products
  def destroy_with_products
    if can_be_destroyed?
      destroy
    else
      # Nếu có products, set artist_id = nil cho tất cả products
      products.update_all(artist_id: nil)
      destroy
    end
  end

  # Trả về URL của ảnh background với variant
  def background_image_url(variant = :medium)
    return nil unless background_image.attached?

    processed_image =
      case variant
      when :thumb
        background_image.variant(resize_to_fill: [ 320, 180 ]).processed
      when :medium
        background_image.variant(resize_to_fill: [ 640, 360 ]).processed
      when :large
        background_image.variant(resize_to_fill: [ 1280, 720 ]).processed
      else
        background_image
      end

    if Rails.application.config.active_storage.service.in?([ :amazon_production, :amazon_development ])
      processed_image.url
    else
      Rails.application.routes.url_helpers.rails_blob_path(processed_image, only_path: true)
    end
  end

  private

  def background_image_presence
    errors.add(:background_image, "must be attached") unless background_image.attached?
  end
end
