# app/models/event.rb
class Event < Spree::Base
  attr_accessor :remove_image_ids
  has_many_attached :images
  has_one_attached :background_image

  has_many :products, class_name: "Spree::Product", dependent: :nullify

  # Enum for status - Rails 8 syntax
  enum :status, { inactive: 0, active: 1 }, default: :inactive

  # Class method để trả về status options cho form select
  def self.status_options
    statuses.map { |key, value| [key.humanize, key] }
  end

  # Validations
  validates :title, :description, :youtube_url, presence: true
  validate :background_image_presence

  # Scopes for admin
  scope :recent, -> { order(created_at: :desc) }
  scope :active, -> { where(status: :active) }
  scope :inactive, -> { where(status: :inactive) }
  
  # Scopes for frontend - sử dụng tên cột mới
  scope :current, -> { active.where('start_time <= ? AND end_time >= ?', Time.current, Time.current) }
  scope :upcoming, -> { active.where('start_time > ?', Time.current).order(:start_time) }
  scope :featured, -> { active.order(:start_time).limit(5) }

  def self.ransackable_attributes(auth_object = nil)
    %w[title description youtube_url statement gallery press_release location status start_time end_time created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[images_attachments images_blobs background_image_attachments background_image_blobs]
  end

  def has_images?
    images.attached?
  end

  def display_image_urls(size = :medium)
    return [] unless has_images?
    
    images.map do |image|
      if image.representable?
        Rails.application.routes.url_helpers.rails_blob_path(image.variant(resize_to_fill: [800, 600]).processed, only_path: true)
      else
        Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
      end
    end
  end

  def background_image_presence
    unless background_image.attached?
      errors.add(:background_image, "must be attached")
    end
  end

  def youtube_thumbnail_url
    return nil unless youtube_url.present?
    
    video_id = extract_youtube_video_id(youtube_url)
    return nil unless video_id
    
    "https://img.youtube.com/vi/#{video_id}/maxresdefault.jpg"
  end

  # Helper methods for display
  def display_duration
    if active?
      "#{location} - Ongoing"
    else
      "#{start_time.strftime('%B %d')} - #{end_time.strftime('%B %d, %Y')}"
    end
  end

  def display_operating_hours
    if start_time.present? && end_time.present?
      "#{start_time.strftime('%A')} - #{end_time.strftime('%A')} | #{start_time.strftime('%I:%M %p')} - #{end_time.strftime('%I:%M %p')}"
    elsif start_time.present?
      "#{start_time.strftime('%A')} | #{start_time.strftime('%I:%M %p')} - Ongoing"
    else
      "Hours not specified"
    end
  end

  def display_image_url(size = :medium)
    if background_image.attached?
      case size
      when :large
        "/rails/active_storage/blobs/redirect/#{background_image.signed_id}/#{background_image.filename}"
      when :medium
        "/rails/active_storage/blobs/redirect/#{background_image.signed_id}/#{background_image.filename}"
      else
        "/rails/active_storage/blobs/redirect/#{background_image.signed_id}/#{background_image.filename}"
      end
    elsif has_images?
      display_image_urls(size).first
    else
      youtube_thumbnail_url
    end
  end

  def is_current?
    start_time.present? && end_time.present? && Time.current.between?(start_time, end_time)
  end

  def is_upcoming?
    start_time.present? && start_time > Time.current
  end

  private

  def extract_youtube_video_id(url)
    return nil unless url.present?
    
    # Handle different YouTube URL formats
    patterns = [
      /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([^&\n?#]+)/,
      /youtube\.com\/v\/([^&\n?#]+)/,
      /youtube\.com\/watch\?.*v=([^&\n?#]+)/
    ]
    
    patterns.each do |pattern|
      match = url.match(pattern)
      return match[1] if match
    end
    
    nil
  end
end
