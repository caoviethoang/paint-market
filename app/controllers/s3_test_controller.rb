class S3TestController < ApplicationController
  def index
  end
  
  def upload
    if params[:file].present?
      begin
        # Tạo file key với prefix "test/"
        file_key = "test/#{Time.current.to_i}_#{params[:file].original_filename}"
        
        # Sử dụng AWS SDK để upload
        require 'aws-sdk-s3'
        
        storage_service = Rails.application.config.active_storage.service_configurations["amazon_development"]
        
        s3_client = Aws::S3::Client.new(
          region: storage_service["region"],
          access_key_id: storage_service["access_key_id"],
          secret_access_key: storage_service["secret_access_key"]
        )
        
        bucket_name = storage_service["bucket"]
        
        # Upload file
        s3_client.put_object(
          bucket: bucket_name,
          key: file_key,
          body: params[:file].read,
          content_type: params[:file].content_type
        )
        
        @success_message = "File uploaded successfully!"
        @file_url = "https://#{bucket_name}.s3.#{storage_service["region"]}.amazonaws.com/#{file_key}"
        
      rescue => e
        @error_message = "Upload failed: #{e.message}"
      end
    else
      @error_message = "Please select a file to upload"
    end
    
    render :index
  end
  
  def list_files
    begin
      require 'aws-sdk-s3'
      
      storage_service = Rails.application.config.active_storage.service_configurations["amazon_development"]
      
      s3_client = Aws::S3::Client.new(
        region: storage_service["region"],
        access_key_id: storage_service["access_key_id"],
        secret_access_key: storage_service["secret_access_key"]
      )
      
      bucket_name = storage_service["bucket"]
      
      # List objects với prefix "test/"
      response = s3_client.list_objects_v2(
        bucket: bucket_name,
        prefix: "test/"
      )
      
      @files = response.contents || []
      
    rescue => e
      @error_message = "Error listing files: #{e.message}"
      @files = []
    end
    
    render :index
  end
end
