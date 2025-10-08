# app/models/artist.rb
class Artist < Spree::Base
  has_one_attached :background_image

  has_many :products, class_name: "Spree::Product", dependent: :nullify

  # Validations
  validates :name, :introduction, :address, presence: true
  validates :start_work, presence: true, numericality: { 
    only_integer: true, 
    greater_than: 1900, 
    less_than_or_equal_to: Date.current.year 
  }
  validate :background_image_presence

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_start_work, ->(year) { where(start_work: year) }
  scope :active_artists, -> { where('start_work >= ?', Date.current.year - 50) }

  def self.ransackable_attributes(auth_object = nil)
    %w[name introduction start_work address created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[background_image_attachment background_image_blob]
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

  # Helper method để tính số năm kinh nghiệm
  def experience_years
    return nil unless start_work
    Date.current.year - start_work
  end

  # Helper method để đếm số sản phẩm
  def products_count
    products.count
  end

  private

  def background_image_presence
    errors.add(:background_image, "must be attached") unless background_image.attached?
  end
end
