# frozen_string_literal: true

# Image optimization for production
Rails.application.config.after_initialize do
  if Rails.env.production?
    # Configure ImageProcessing for better memory management
    if defined?(ImageProcessing)
      ImageProcessing.configure do |config|
        # Use VIPS instead of ImageMagick for better memory efficiency
        config.shell_api = "posix-spawn"
        config.timeout = 30
      end
    end

    # Configure Active Storage variants to be more memory efficient
    Rails.application.config.active_storage.tap do |config|
      # Limit variant processing to prevent memory issues
      config.variant_processor = :mini_magick
      
      # Set reasonable limits for image processing
      config.variant_limits = {
        resize_to_limit: [1920, 1080], # Max resolution
        resize_to_fit: [1920, 1080],
        resize_to_fill: [1920, 1080]
      }
    end

    Rails.logger.info "🖼️ Image optimization configured for production"
  end
end
