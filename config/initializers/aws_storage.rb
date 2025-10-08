# frozen_string_literal: true

# AWS Storage Configuration for Solidus
Rails.application.config.after_initialize do
  # Log current storage configuration
  current_service = Rails.application.config.active_storage.service
  Rails.logger.info "🚀 Active Storage Service: #{current_service}"
  
  # Only configure AWS if using S3 service
  if current_service.to_s.start_with?('amazon_')
    # Check if AWS credentials are properly configured
    bucket_name = ENV['AWS_BUCKET_PROD'] || ENV['AWS_BUCKET_DEV']
    region = ENV['AWS_REGION']
    
    if bucket_name.blank? || region.blank?
      Rails.logger.error "❌ AWS configuration incomplete:"
      Rails.logger.error "  Bucket: #{bucket_name || 'NOT SET'}"
      Rails.logger.error "  Region: #{region || 'NOT SET'}"
      Rails.logger.error "  Please check your environment variables"
      next
    end
    
    Rails.logger.info "📦 S3 Configuration:"
    Rails.logger.info "  Bucket: #{bucket_name}"
    Rails.logger.info "  Region: #{region}"
    Rails.logger.info "  Service: S3"
    
    # Test S3 connection in development only
    if Rails.env.development?
      begin
        s3_client = Aws::S3::Client.new(
          region: region,
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        )
        
        # Test bucket access
        s3_client.head_bucket(bucket: bucket_name)
        Rails.logger.info "✅ S3 connection successful for bucket: #{bucket_name}"
      rescue => e
        Rails.logger.error "❌ S3 connection failed: #{e.message}"
        Rails.logger.error "Please check your AWS credentials and bucket configuration"
      end
    end
  else
    # Local storage configuration
    if current_service == :local
      storage_path = Rails.root.join('storage')
      Rails.logger.info "📁 Local Storage Configuration:"
      Rails.logger.info "  Path: #{storage_path}"
      Rails.logger.info "  Service: Local Disk"
      
      # Ensure storage directory exists
      unless Dir.exist?(storage_path)
        Dir.mkdir(storage_path)
        Rails.logger.info "✅ Created storage directory: #{storage_path}"
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
