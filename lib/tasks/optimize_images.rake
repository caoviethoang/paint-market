namespace :images do
  desc "Optimize banner.png for web performance"
  task optimize_banner: :environment do
    require 'image_processing/vips'
    
    banner_path = Rails.root.join('app/assets/images/banner.png')
    output_path = Rails.root.join('app/assets/images/banner_optimized.png')
    
    if File.exist?(banner_path)
      puts "Optimizing banner.png..."
      
      # Tối ưu ảnh banner
      ImageProcessing::Vips.source(banner_path.to_s)
        .resize_to_limit(1920, 800)  # Giảm độ phân giải
        .saver(quality: 85)          # Giảm quality để giảm kích thước
        .call(destination: output_path.to_s)
      
      # So sánh kích thước
      original_size = File.size(banner_path)
      optimized_size = File.size(output_path)
      
      puts "Original size: #{original_size / 1024 / 1024.0} MB"
      puts "Optimized size: #{optimized_size / 1024 / 1024.0} MB"
      puts "Reduction: #{((original_size - optimized_size) / original_size.to_f * 100).round(2)}%"
      
      # Backup ảnh gốc và thay thế
      backup_path = Rails.root.join('app/assets/images/banner_original.png')
      FileUtils.cp(banner_path, backup_path)
      FileUtils.mv(output_path, banner_path)
      
      puts "✅ Banner optimized successfully!"
      puts "📁 Original backed up to: banner_original.png"
    else
      puts "❌ Banner file not found at #{banner_path}"
    end
  end
  
  desc "Create multiple banner sizes for responsive design"
  task create_responsive_banners: :environment do
    require 'image_processing/vips'
    
    banner_path = Rails.root.join('app/assets/images/banner.png')
    
    if File.exist?(banner_path)
      puts "Creating responsive banner sizes..."
      
      # Desktop (1920x800)
      ImageProcessing::Vips.source(banner_path.to_s)
        .resize_to_limit(1920, 800)
        .saver(quality: 85)
        .call(destination: Rails.root.join('app/assets/images/banner_desktop.png').to_s)
      
      # Tablet (1024x600)
      ImageProcessing::Vips.source(banner_path.to_s)
        .resize_to_limit(1024, 600)
        .saver(quality: 80)
        .call(destination: Rails.root.join('app/assets/images/banner_tablet.png').to_s)
      
      # Mobile (768x400)
      ImageProcessing::Vips.source(banner_path.to_s)
        .resize_to_limit(768, 400)
        .saver(quality: 75)
        .call(destination: Rails.root.join('app/assets/images/banner_mobile.png').to_s)
      
      puts "✅ Responsive banners created!"
      puts "📱 Desktop: 1920x800"
      puts "📱 Tablet: 1024x600" 
      puts "📱 Mobile: 768x400"
    else
      puts "❌ Banner file not found!"
    end
  end
end 