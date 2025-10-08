# Hướng dẫn tạo file .env cho AWS Storage

## Bước 1: Tạo file .env

Tạo file `.env` trong thư mục gốc của dự án với nội dung sau:

```bash
# AWS Credentials
AWS_ACCESS_KEY_ID=your_actual_access_key_id
AWS_SECRET_ACCESS_KEY=your_actual_secret_access_key
AWS_REGION=ap-southeast-1

# AWS Buckets
AWS_BUCKET_DEV=your-dev-bucket-name
AWS_BUCKET_PROD=your-prod-bucket-name

# Rails Environment
RAILS_ENV=development
```

## Bước 2: Thay thế các giá trị

### AWS Credentials
- `AWS_ACCESS_KEY_ID`: Access Key ID từ AWS IAM
- `AWS_SECRET_ACCESS_KEY`: Secret Access Key từ AWS IAM
- `AWS_REGION`: Region của AWS (ví dụ: ap-southeast-1, us-east-1)

### AWS Buckets
- `AWS_BUCKET_DEV`: Tên bucket cho development
- `AWS_BUCKET_PROD`: Tên bucket cho production

## Bước 3: Tạo S3 Buckets

1. Đăng nhập vào AWS Console
2. Vào S3 service
3. Tạo 2 bucket:
   - **Development bucket**: `your-dev-bucket-name`
   - **Production bucket**: `your-prod-bucket-name`

## Bước 4: Cấu hình IAM User

Tạo IAM user với policy sau:

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
                "arn:aws:s3:::your-dev-bucket-name",
                "arn:aws:s3:::your-dev-bucket-name/*",
                "arn:aws:s3:::your-prod-bucket-name",
                "arn:aws:s3:::your-prod-bucket-name/*"
            ]
        }
    ]
}
```

## Bước 5: Test cấu hình

Sau khi tạo file `.env`, restart server và kiểm tra logs:

```bash
bin/rails server
```
## Lưu ý quan trọng

1. **KHÔNG commit file `.env`** vào git
2. File `.env` đã được thêm vào `.gitignore`
3. Restart server sau khi thay đổi file `.env`
4. Kiểm tra logs để đảm bảo cấu hình đúng

## Troubleshooting

### Lỗi "AWS service configuration not found"
- Kiểm tra `config/storage.yml`
- Đảm bảo service name đúng

### Lỗi "AWS configuration incomplete"
- Kiểm tra file `.env`
- Đảm bảo tất cả biến môi trường đã được set

### Lỗi "S3 connection failed"
- Kiểm tra AWS credentials
- Kiểm tra IAM permissions
- Kiểm tra bucket name và region
