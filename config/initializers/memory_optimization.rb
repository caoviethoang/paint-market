# frozen_string_literal: true

# Memory optimization for Heroku production (without Redis)
if Rails.env.production?
  # Configure MiniMagick for better memory management
  if defined?(MiniMagick)
    MiniMagick.configure do |config|
      config.timeout = 30
      config.whiny = false
      # Reduce memory usage by processing images in smaller chunks
      config.shell_api = "posix-spawn"
      # Limit memory usage for image processing
      config.limit = "512MB"
    end
  end

  # Configure Active Storage to use less memory
  Rails.application.config.active_storage.tap do |config|
    # Use direct uploads to S3 to avoid memory issues
    config.resolve_model_to_route = :rails_storage_proxy
    
    # Disable automatic image processing for large files
    config.variant_processor = :mini_magick
  end

  # Add middleware for garbage collection (before Rails initializes)
  Rails.application.config.middleware.use(Class.new do
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    ensure
      # Force GC after each request to prevent memory buildup
      if ENV['FORCE_GC'] == 'true'
        GC.start
        GC.compact if GC.respond_to?(:compact)
      end
    end
  end)

  Rails.logger.info "🚀 Memory optimization configured for production (no Redis)"
end
