# frozen_string_literal: true

# Image optimization for production
Rails.application.config.after_initialize do
  if Rails.env.production?
    # Configure Active Storage variants to be more memory efficient
    Rails.application.config.active_storage.tap do |config|
      # Limit variant processing to prevent memory issues
      config.variant_processor = :mini_magick
    end

    Rails.logger.info "🖼️ Image optimization configured for production"
  end
end
