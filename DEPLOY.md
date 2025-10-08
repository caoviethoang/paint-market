# Hướng dẫn Deploy lên Heroku

## Bước 1: Cài đặt Heroku CLI

Nếu bạn chưa cài đặt Heroku CLI, hãy tải về từ: https://devcenter.heroku.com/articles/heroku-cli

## Bước 2: Đăng nhập vào Heroku

```bash
heroku login
```

## Bước 3: Tạo ứng dụng trên Heroku

```bash
heroku create your-app-name
```

## Bước 4: Thêm PostgreSQL addon

```bash
heroku addons:create heroku-postgresql:mini
```

## Bước 5: Thêm Redis addon (nếu cần)

```bash
heroku addons:create heroku-redis:mini
```

## Bước 6: Cấu hình environment variables

```bash
# Rails master key
heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)

# Rails environment
heroku config:set RAILS_ENV=production

# Database URL (tự động được set bởi PostgreSQL addon)
# DATABASE_URL sẽ được set tự động

# AWS S3 credentials (nếu sử dụng S3)
heroku config:set AWS_ACCESS_KEY_ID=your_access_key
heroku config:set AWS_SECRET_ACCESS_KEY=your_secret_key
heroku config:set AWS_REGION=your_region
heroku config:set AWS_BUCKET_PROD=your_production_bucket

# Các biến môi trường khác
heroku config:set RAILS_SERVE_STATIC_FILES=true
heroku config:set RAILS_LOG_TO_STDOUT=true
```

## Bước 7: Deploy ứng dụng

```bash
git add .
git commit -m "Prepare for Heroku deployment"
git push heroku main
```

## Bước 8: Chạy database migrations

```bash
heroku run rails db:migrate
```

## Bước 9: Tạo database seed data (nếu cần)

```bash
heroku run rails db:seed
```

## Bước 10: Mở ứng dụng

```bash
heroku open
```

## Lưu ý quan trọng:

1. **Database**: Ứng dụng sẽ sử dụng PostgreSQL từ Heroku
2. **Storage**: Ứng dụng được cấu hình để sử dụng AWS S3. Hãy đảm bảo bạn đã cấu hình đúng AWS credentials
3. **Static Files**: Rails sẽ serve static files trong production
4. **Logs**: Logs sẽ được ghi ra STDOUT để Heroku có thể capture

## Troubleshooting:

- Kiểm tra logs: `heroku logs --tail`
- Kiểm tra config: `heroku config`
- Restart app: `heroku restart`
- Kiểm tra database: `heroku pg:info`

## Cập nhật ứng dụng:

```bash
git add .
git commit -m "Update message"
git push heroku main
```
