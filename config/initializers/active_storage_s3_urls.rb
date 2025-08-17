# frozen_string_literal: true

# Configure Active Storage to use S3 URLs
Rails.application.config.after_initialize do
  if Rails.application.config.active_storage.service.to_s.start_with?('amazon_')
    # Log S3 configuration
    Rails.logger.info "🚀 Active Storage configured to use S3 URLs"
    Rails.logger.info "  Service: #{Rails.application.config.active_storage.service}"
    Rails.logger.info "  Bucket: #{ENV['AWS_BUCKET_DEV'] || ENV['AWS_BUCKET_PROD']}"
    Rails.logger.info "  Region: #{ENV['AWS_REGION']}"
  end
end
