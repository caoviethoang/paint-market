namespace :storage do
  desc "Migrate files from local storage to S3"
  task migrate_to_s3: :environment do
    puts "Starting migration from local storage to S3..."
    
    # Check current service
    current_service = Rails.application.config.active_storage.service
    puts "Current storage service: #{current_service}"
    
    if current_service == :amazon_production || current_service == :amazon_development
      puts "✅ Already using S3 service: #{current_service}"
    else
      puts "⚠️  Not using S3 service. Current: #{current_service}"
      puts "Please switch to S3 service first:"
      puts "  - Development: config.active_storage.service = :amazon_development"
      puts "  - Production: config.active_storage.service = :amazon_production"
      exit 1
    end
    
    # Migrate Event images
    puts "\nMigrating Event images..."
    event_count = 0
    Event.find_each do |event|
      if event.images.attached?
        event.images.each do |image|
          begin
            # Check if image is already on S3
            if image.service_name == current_service.to_s
              puts "  Event #{event.id}: Image #{image.filename} already on S3"
              next
            end
            
            # Download from local and upload to S3
            puts "  Event #{event.id}: Migrating image #{image.filename}..."
            image.blob.open do |file|
              # Create new attachment on S3
              event.images.attach(
                io: file,
                filename: image.filename,
                content_type: image.content_type
              )
            end
            event_count += 1
          rescue => e
            puts "  ❌ Error migrating Event #{event.id} image: #{e.message}"
          end
        end
      end
      
      if event.background_image.attached?
        begin
          if event.background_image.service_name == current_service.to_s
            puts "  Event #{event.id}: Background image already on S3"
            next
          end
          
          puts "  Event #{event.id}: Migrating background image #{event.background_image.filename}..."
          event.background_image.blob.open do |file|
            event.background_image.attach(
              io: file,
              filename: event.background_image.filename,
              content_type: event.background_image.content_type
            )
          end
          event_count += 1
        rescue => e
          puts "  ❌ Error migrating Event #{event.id} background image: #{e.message}"
        end
      end
    end
    
    # Migrate Artist background images
    puts "\nMigrating Artist background images..."
    artist_count = 0
    Artist.find_each do |artist|
      if artist.background_image.attached?
        begin
          if artist.background_image.service_name == current_service.to_s
            puts "  Artist #{artist.id}: Background image already on S3"
            next
          end
          
          puts "  Artist #{artist.id}: Migrating background image #{artist.background_image.filename}..."
          artist.background_image.blob.open do |file|
            artist.background_image.attach(
              io: file,
              filename: artist.background_image.filename,
              content_type: artist.background_image.content_type
            )
          end
          artist_count += 1
        rescue => e
          puts "  ❌ Error migrating Artist #{artist.id} background image: #{e.message}"
        end
      end
    end
    
    puts "\nMigration completed!"
    puts "Total files migrated: #{event_count + artist_count}"
    puts "  - Event files: #{event_count}"
    puts "  - Artist files: #{artist_count}"
  end
  
  desc "Clean up old local files after S3 migration"
  task cleanup_local: :environment do
    puts "⚠️  WARNING: This will delete local files after S3 migration!"
    puts "Make sure all files are successfully migrated to S3 first."
    puts "Run 'rake storage:migrate_to_s3' to migrate files first."
    
    print "Are you sure you want to continue? (yes/no): "
    confirmation = STDIN.gets.chomp.downcase
    
    if confirmation != 'yes'
      puts "Cleanup cancelled."
      exit 0
    end
    
    puts "\nStarting cleanup of local files..."
    
    # Clean up Event images
    event_count = 0
    Event.find_each do |event|
      if event.images.attached?
        event.images.each do |image|
          begin
            # Only delete if image is on S3
            if image.service_name != 'Disk'
              puts "  Event #{event.id}: Image #{image.filename} is on S3, skipping..."
              next
            end
            
            puts "  Event #{event.id}: Deleting local image #{image.filename}..."
            image.purge
            event_count += 1
          rescue => e
            puts "  ❌ Error cleaning up Event #{event.id} image: #{e.message}"
          end
        end
      end
      
      if event.background_image.attached?
        begin
          if event.background_image.service_name != 'Disk'
            puts "  Event #{event.id}: Background image is on S3, skipping..."
            next
          end
          
          puts "  Event #{event.id}: Deleting local background image #{event.background_image.filename}..."
          event.background_image.purge
          event_count += 1
        rescue => e
          puts "  ❌ Error cleaning up Event #{event.id} background image: #{e.message}"
        end
      end
    end
    
    # Clean up Artist background images
    artist_count = 0
    Artist.find_each do |artist|
      if artist.background_image.attached?
        begin
          if artist.background_image.service_name != 'Disk'
            puts "  Artist #{artist.id}: Background image is on S3, skipping..."
            next
          end
          
          puts "  Artist #{artist.id}: Deleting local background image #{artist.background_image.filename}..."
          artist.background_image.purge
          artist_count += 1
        rescue => e
          puts "  ❌ Error cleaning up Artist #{artist.id} background image: #{e.message}"
        end
      end
    end
    
    puts "\nCleanup completed!"
    puts "Total local files removed: #{event_count + artist_count}"
    puts "  - Event files: #{event_count}"
    puts "  - Artist files: #{artist_count}"
    
    # Clean up storage directory
    puts "\nCleaning up storage directory..."
    storage_path = Rails.root.join('storage')
    if Dir.exist?(storage_path)
      FileUtils.rm_rf(storage_path)
      puts "✅ Storage directory cleaned up"
    else
      puts "Storage directory not found"
    end
  end
  
  desc "Check storage usage and file locations"
  task status: :environment do
    puts "Storage Status Report"
    puts "=" * 50
    
    current_service = Rails.application.config.active_storage.service
    puts "Current Active Storage service: #{current_service}"
    
    # Check Event attachments
    puts "\nEvent Attachments:"
    events = Event.left_joins(:images_attachments, :background_image_attachment)
    events_with_images = events.where.not(active_storage_attachments: { id: nil }).distinct.count
    events_with_bg = events.where.not(active_storage_background_image_attachments: { id: nil }).distinct.count
    
    puts "  Total events: #{Event.count}"
    puts "  Events with images: #{events_with_images}"
    puts "  Events with background images: #{events_with_bg}"
    
    # Check Artist attachments
    puts "\nArtist Attachments:"
    artists = Artist.left_joins(:background_image_attachment)
    artists_with_bg = artists.where.not(active_storage_background_image_attachments: { id: nil }).distinct.count
    
    puts "  Total artists: #{Artist.count}"
    puts "  Artists with background images: #{artists_with_bg}"
    
    # Check file locations
    puts "\nFile Storage Locations:"
    disk_count = 0
    s3_count = 0
    
    Event.find_each do |event|
      if event.images.attached?
        event.images.each do |image|
          if image.service_name == 'Disk'
            disk_count += 1
          elsif image.service_name.include?('S3')
            s3_count += 1
          end
        end
      end
      
      if event.background_image.attached?
        if event.background_image.service_name == 'Disk'
          disk_count += 1
        elsif event.background_image.service_name.include?('S3')
          s3_count += 1
        end
      end
    end
    
    Artist.find_each do |artist|
      if artist.background_image.attached?
        if artist.background_image.service_name == 'Disk'
          disk_count += 1
        elsif artist.background_image.service_name.include?('S3')
          s3_count += 1
        end
      end
    end
    
    puts "  Files on local disk: #{disk_count}"
    puts "  Files on S3: #{s3_count}"
    
    if disk_count > 0 && current_service.to_s.include?('S3')
      puts "\n⚠️  You have files on local disk but are using S3 service."
      puts "   Consider running 'rake storage:migrate_to_s3' to migrate files."
    elsif s3_count > 0 && current_service == :local
      puts "\n⚠️  You have files on S3 but are using local service."
      puts "   Consider switching to S3 service in your environment config."
    end
  end
end 