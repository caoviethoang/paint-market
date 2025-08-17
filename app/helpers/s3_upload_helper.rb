module S3UploadHelper
  def upload_to_test_folder(file, custom_filename = nil)
    require 'aws-sdk-s3'
    
    # Sử dụng cấu hình Active Storage service
    storage_service = Rails.application.config.active_storage.service_configurations[:amazon_development]
    
    s3_client = Aws::S3::Client.new(
      region: storage_service["region"],
      access_key_id: storage_service["access_key_id"],
      secret_access_key: storage_service["secret_access_key"]
    )
    
    bucket_name = storage_service["bucket"]
    
    # Tạo filename với timestamp để tránh trùng lặp
    filename = custom_filename || "#{Time.current.to_i}_#{file.original_filename}"
    # Tự động thêm prefix "test/" vào file key
    file_key = "test/#{filename}"
    
    begin
      # Upload file mà không cần ACLs
      s3_client.put_object(
        bucket: bucket_name,
        key: file_key,
        body: file.read,
        content_type: file.content_type
        # Không cần acl parameter
      )
      
      # Trả về URL của file
      {
        success: true,
        url: "https://#{bucket_name}.s3.#{storage_service["region"]}.amazonaws.com/#{file_key}",
        key: file_key,
        filename: filename
      }
      
    rescue => e
      {
        success: false,
        error: e.message
      }
    end
  end
  
  def list_test_folder_files
    require 'aws-sdk-s3'
    
    storage_service = Rails.application.config.active_storage.service_configurations[:amazon_development]
    
    s3_client = Aws::S3::Client.new(
      region: storage_service["region"],
      access_key_id: storage_service["access_key_id"],
      secret_access_key: storage_service["secret_access_key"]
    )
    
    bucket_name = storage_service["bucket"]
    
    begin
      response = s3_client.list_objects_v2(
        bucket: bucket_name,
        prefix: "test/"
      )
      
      response.contents || []
    rescue => e
      []
    end
  end
  
  def delete_test_file(file_key)
    require 'aws-sdk-s3'
    
    storage_service = Rails.application.config.active_storage.service_configurations[:amazon_development]
    
    s3_client = Aws::S3::Client.new(
      region: storage_service["region"],
      access_key_id: storage_service["access_key_id"],
      secret_access_key: storage_service["secret_access_key"]
    )
    
    bucket_name = storage_service["bucket"]
    
    begin
      s3_client.delete_object(
        bucket: bucket_name,
        key: file_key
      )
      
      { success: true }
    rescue => e
      { success: false, error: e.message }
    end
  end
end
