# Paint Market

Ứng dụng e-commerce được xây dựng với Solidus và Rails 8.

## Tính năng

- Quản lý sản phẩm và danh mục
- Hệ thống giỏ hàng và thanh toán
- Quản lý đơn hàng
- Hệ thống xác thực người dùng
- Giao diện admin
- Hỗ trợ đa ngôn ngữ (Tiếng Anh, Tiếng Việt)

## Cài đặt

### Yêu cầu hệ thống

- Ruby 3.2+
- PostgreSQL
- Redis (tùy chọn)
- Node.js (cho Tailwind CSS)

### Cài đặt dependencies

```bash
bundle install
npm install
```

### Cấu hình database

```bash
rails db:create
rails db:migrate
rails db:seed
```

### Chạy ứng dụng

```bash
rails server
```

Ứng dụng sẽ chạy tại http://localhost:3000

## Deploy lên Heroku

### Cách 1: Sử dụng script tự động (Khuyến nghị)

```bash
# Cấp quyền thực thi cho script
chmod +x deploy.sh

# Chạy script deploy
./deploy.sh your-app-name
```

### Cách 2: Deploy thủ công

1. **Cài đặt Heroku CLI**
   ```bash
   # Tải từ: https://devcenter.heroku.com/articles/heroku-cli
   ```

2. **Đăng nhập Heroku**
   ```bash
   heroku login
   ```

3. **Tạo ứng dụng**
   ```bash
   heroku create your-app-name
   ```

4. **Thêm addons**
   ```bash
   heroku addons:create heroku-postgresql:mini
   heroku addons:create heroku-redis:mini
   ```

5. **Cấu hình environment variables**
   ```bash
   heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)
   heroku config:set RAILS_ENV=production
   heroku config:set RAILS_SERVE_STATIC_FILES=true
   heroku config:set RAILS_LOG_TO_STDOUT=true
   ```

6. **Deploy**
   ```bash
   git push heroku main
   heroku run rails db:migrate
   ```

### Cấu hình AWS S3 (nếu sử dụng)

```bash
heroku config:set AWS_ACCESS_KEY_ID=your_access_key
heroku config:set AWS_SECRET_ACCESS_KEY=your_secret_key
heroku config:set AWS_REGION=your_region
heroku config:set AWS_BUCKET_PROD=your_production_bucket
```

## Cấu trúc dự án

```
paint-market/
├── app/                    # Application code
│   ├── controllers/       # Controllers
│   ├── models/           # Models
│   ├── views/            # Views
│   ├── components/       # View Components
│   └── assets/           # Assets (CSS, JS, Images)
├── config/               # Configuration files
├── db/                   # Database files
├── spec/                 # Tests
└── vendor/               # Third-party code
```

## Testing

```bash
bundle exec rspec
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License.
