# frozen_string_literal: true

# AWS Storage Configuration for Solidus
Rails.application.config.after_initialize do
  # Log current storage configuration
  current_service = Rails.application.config.active_storage.service
  Rails.logger.info "🚀 Active Storage Service: #{current_service}"
  
  # Log S3 configuration if using S3
  if current_service.to_s.start_with?('amazon_')
    # Check if AWS credentials are properly configured
    if ENV['AWS_BUCKET_DEV'].blank? || ENV['AWS_REGION'].blank?
      Rails.logger.error "❌ AWS configuration incomplete:"
      Rails.logger.error "  Bucket: #{ENV['AWS_BUCKET_DEV'] || 'NOT SET'}"
      Rails.logger.error "  Region: #{ENV['AWS_REGION'] || 'NOT SET'}"
      Rails.logger.error "  Please check your .env file and environment variables"
      return
    end
    
    Rails.logger.info "📦 S3 Configuration:"
    Rails.logger.info "  Bucket: #{ENV['AWS_BUCKET_DEV']}"
    Rails.logger.info "  Region: #{ENV['AWS_REGION']}"
    Rails.logger.info "  Service: S3"
    
    # Test S3 connection in development
    if Rails.env.development?
      begin
        s3_client = Aws::S3::Client.new(
          region: ENV['AWS_REGION'],
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        )
        
        # Test bucket access
        s3_client.head_bucket(bucket: ENV['AWS_BUCKET_DEV'])
        Rails.logger.info "✅ S3 connection successful for bucket: #{ENV['AWS_BUCKET_DEV']}"
      rescue => e
        Rails.logger.error "❌ S3 connection failed: #{e.message}"
        Rails.logger.error "Please check your AWS credentials and bucket configuration"
      end
    end
  end
end

# Configure Active Storage for Solidus
Rails.application.config.to_prepare do
  # Log Solidus configuration
  if defined?(Spree)
    Rails.logger.info "🔧 Solidus Active Storage configuration loaded"
  end
end
