namespace :s3 do
  desc "Test S3 connection and bucket access"
  task test: :environment do
    puts "Testing S3 connection..."
    
    begin
      # Test current storage service
      current_service = Rails.application.config.active_storage.service
      puts "Current Active Storage service: #{current_service}"
      
      # Test S3 configuration
      config = Rails.application.config.active_storage.service_configurations[current_service]
      puts "S3 Configuration:"
      puts "  Service: #{config[:service]}"
      puts "  Bucket: #{config[:bucket]}"
      puts "  Region: #{config[:region]}"
      puts "  Access Key ID: #{config[:access_key_id] ? config[:access_key_id][0..7] + '...' : 'Not set'}"
      
      # Test bucket access
      s3_client = Aws::S3::Client.new(
        region: config[:region],
        access_key_id: config[:access_key_id],
        secret_access_key: config[:secret_access_key]
      )
      
      puts "\nTesting bucket access..."
      bucket_name = config[:bucket]
      response = s3_client.head_bucket(bucket: bucket_name)
      puts "✅ Successfully connected to bucket: #{bucket_name}"
      
      # Test list objects
      puts "\nTesting list objects..."
      list_response = s3_client.list_objects_v2(bucket: bucket_name, max_keys: 5)
      object_count = list_response.contents.count
      puts "✅ Bucket contains #{object_count} objects"
      
      if object_count > 0
        puts "First few objects:"
        list_response.contents.first(3).each do |obj|
          puts "  - #{obj.key} (#{obj.size} bytes)"
        end
      end
      
      # Test Active Storage service
      puts "\nTesting Active Storage service..."
      if Rails.application.config.active_storage.service == :amazon_production
        puts "✅ Production is configured to use S3"
      else
        puts "⚠️  Production is NOT configured to use S3"
        puts "   Current service: #{Rails.application.config.active_storage.service}"
      end
      
    rescue Aws::S3::Errors::NoSuchBucket => e
      puts "❌ Bucket not found: #{e.message}"
    rescue Aws::S3::Errors::AccessDenied => e
      puts "❌ Access denied: #{e.message}"
      puts "   Check your IAM permissions and bucket policy"
    rescue Aws::S3::Errors::InvalidAccessKeyId => e
      puts "❌ Invalid access key: #{e.message}"
      puts "   Check your AWS_ACCESS_KEY_ID"
    rescue Aws::S3::Errors::SignatureDoesNotMatch => e
      puts "❌ Invalid secret key: #{e.message}"
      puts "   Check your AWS_SECRET_ACCESS_KEY"
    rescue => e
      puts "❌ Error: #{e.message}"
      puts "   Class: #{e.class}"
    end
    
    puts "\nTest completed!"
  end
  
  desc "List all S3 buckets for current AWS account"
  task list_buckets: :environment do
    puts "Listing all S3 buckets..."
    
    begin
      config = Rails.application.config.active_storage.service_configurations[Rails.application.config.active_storage.service]
      
      s3_client = Aws::S3::Client.new(
        region: config[:region],
        access_key_id: config[:access_key_id],
        secret_access_key: config[:secret_access_key]
      )
      
      response = s3_client.list_buckets
      puts "Available buckets:"
      response.buckets.each do |bucket|
        puts "  - #{bucket.name} (created: #{bucket.creation_date})"
      end
      
    rescue => e
      puts "❌ Error listing buckets: #{e.message}"
    end
  end
  
  desc "Check Active Storage attachments and their storage location"
  task check_attachments: :environment do
    puts "Checking Active Storage attachments..."
    
    # Check Event model
    event_count = Event.count
    events_with_images = Event.joins(:images_attachments).distinct.count
    events_with_bg = Event.joins(:background_image_attachment).distinct.count
    
    puts "Events:"
    puts "  Total: #{event_count}"
    puts "  With images: #{events_with_images}"
    puts "  With background image: #{events_with_bg}"
    
    # Check Artist model
    artist_count = Artist.count
    artists_with_bg = Artist.joins(:background_image_attachment).distinct.count
    
    puts "Artists:"
    puts "  Total: #{artist_count}"
    puts "  With background image: #{artists_with_bg}"
    
    # Check storage service for attachments
    puts "\nStorage service for attachments:"
    current_service = Rails.application.config.active_storage.service
    puts "  Current service: #{current_service}"
    
    if current_service == :amazon_production
      puts "  ✅ Files will be stored on S3"
    else
      puts "  ⚠️  Files are stored locally"
    end
  end
end 