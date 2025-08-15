# Hướng dẫn Setup AWS S3 cho Active Storage

## Tình trạng hiện tại ✅

Dự án đã được cấu hình sẵn để sử dụng AWS S3 trên production:

- **Gem**: `aws-sdk-s3` đã có trong Gemfile
- **Storage config**: `config/storage.yml` đã cấu hình S3
- **Environment**: Production đã set `config.active_storage.service = :amazon_production`
- **Models**: `Event` và `Artist` đã sử dụng Active Storage

## Bước 1: Tạo S3 Bucket trên AWS

1. Đăng nhập vào AWS Console
2. Vào S3 service
3. Tạo 2 bucket:
   - **Development bucket**: `paint-market-dev` (hoặc tên bạn muốn)
   - **Production bucket**: `paint-market-prod` (hoặc tên bạn muốn)

### Cấu hình Bucket:
- **Region**: Chọn region gần nhất (ví dụ: `ap-southeast-1`)
- **Block Public Access**: Bỏ chọn nếu muốn public access
- **Versioning**: Tùy chọn
- **Encryption**: Sử dụng default encryption

## Bước 2: Tạo IAM User

1. Vào IAM service
2. Tạo user mới với quyền truy cập S3
3. Attach policy: `AmazonS3FullAccess` (hoặc tạo custom policy)

### Custom Policy (khuyến nghị):
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::paint-market-dev",
                "arn:aws:s3:::paint-market-dev/*",
                "arn:aws:s3:::paint-market-prod",
                "arn:aws:s3:::paint-market-prod/*"
            ]
        }
    ]
}
```

## Bước 3: Cập nhật file .env

Cập nhật file `.env` với thông tin thực tế:

```bash
# AWS Credentials
AWS_ACCESS_KEY_ID=your_actual_access_key_id
AWS_SECRET_ACCESS_KEY=your_actual_secret_access_key
AWS_REGION=ap-southeast-1
AWS_BUCKET_DEV=paint-market-dev
AWS_BUCKET_PROD=paint-market-prod
```

## Bước 4: Cấu hình Production Server

### Option 1: Environment Variables
```bash
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_REGION=ap-southeast-1
export AWS_BUCKET_PROD=paint-market-prod
```

### Option 2: Rails Credentials (Khuyến nghị)
```bash
# Chỉnh sửa credentials
bin/rails credentials:edit

# Thêm vào file:
aws:
  access_key_id: your_access_key
  secret_access_key: your_secret_key
  region: ap-southeast-1
  bucket_prod: paint-market-prod
```

Sau đó cập nhật `config/storage.yml`:
```yaml
amazon_production:
  service: S3
  access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
  secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
  region: <%= Rails.application.credentials.dig(:aws, :region) %>
  bucket: <%= Rails.application.credentials.dig(:aws, :bucket_prod) %>
  public: true
```

## Bước 5: Test Upload

### Development:
```bash
# Uncomment trong config/environments/development.rb
config.active_storage.service = :amazon_development
```

### Production:
```bash
# Kiểm tra service đang sử dụng
bin/rails console
> Rails.application.config.active_storage.service
# Kết quả: :amazon_production
```

## Bước 6: Migration từ Local Storage

Nếu bạn đã có files trong local storage và muốn migrate lên S3:

```ruby
# Trong Rails console
Event.find_each do |event|
  if event.images.attached?
    event.images.each do |image|
      # Download từ local và upload lên S3
      image.blob.open do |file|
        event.images.attach(io: file, filename: image.filename, content_type: image.content_type)
      end
    end
  end
end
```

## Troubleshooting

### Lỗi thường gặp:

1. **Access Denied**: Kiểm tra IAM permissions
2. **Bucket not found**: Kiểm tra tên bucket và region
3. **Invalid credentials**: Kiểm tra access key và secret key

### Debug:
```ruby
# Trong Rails console
> Rails.application.config.active_storage.service
> Rails.application.config.active_storage.service_configurations
```

## Lưu ý bảo mật

- **KHÔNG** commit file `.env` lên git
- Sử dụng IAM roles thay vì access keys khi có thể
- Giới hạn quyền truy cập S3 theo nguyên tắc least privilege
- Enable CloudTrail để log tất cả S3 operations
- Sử dụng KMS encryption cho sensitive data

## Kiểm tra hoạt động

1. Upload file mới qua form
2. Kiểm tra file có trong S3 bucket không
3. Kiểm tra URL của file có thể access được không
4. Test variant processing (nếu có sử dụng image_processing) 