# Hướng dẫn Deploy lên Heroku

## Bước 1: Cài đặt Heroku CLI

```bash
# Ubuntu/Debian
curl https://cli-assets.heroku.com/install.sh | sh

# Hoặc sử dụng snap
sudo snap install heroku --classic
```

## Bước 2: Đăng nhập Heroku

```bash
heroku login
```

## Bước 3: Tạo ứng dụng Heroku

```bash
heroku create your-app-name
```

## Bước 4: Thêm PostgreSQL addon

```bash
heroku addons:create heroku-postgresql:mini
```

## Bước 5: Cấu hình biến môi trường

```bash
# Rails configuration
heroku config:set RAILS_ENV=production
heroku config:set RAILS_SERVE_STATIC_FILES=true
heroku config:set RAILS_LOG_TO_STDOUT=true
heroku config:set RAILS_MAX_THREADS=5
heroku config:set WEB_CONCURRENCY=2

# Host configuration
heroku config:set HOST=your-app-name.herokuapp.com

# Secret key base
heroku config:set SECRET_KEY_BASE=$(rails secret)

# Database URL (sẽ được tự động set khi thêm PostgreSQL addon)
```

## Bước 6: Deploy ứng dụng

```bash
# Đảm bảo tất cả thay đổi đã được commit
git add .
git commit -m "Prepare for Heroku deployment"

# Push lên Heroku
git push heroku main

# Chạy migration
heroku run rails db:migrate

# Tạo admin user (nếu cần)
heroku run rails console
# Trong console:
# user = Spree::User.create!(email: 'admin@example.com', password: 'password123', password_confirmation: 'password123')
# user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
```

## Bước 7: Mở ứng dụng

```bash
heroku open
```

## Lưu ý quan trọng:

1. **Database**: Heroku sẽ tự động cung cấp DATABASE_URL
2. **File uploads**: Hiện tại sử dụng local storage, sẽ bị mất khi dyno restart
3. **Assets**: Rails sẽ tự động precompile assets
4. **Logs**: Xem logs bằng lệnh `heroku logs --tail`

## Troubleshooting:

- Nếu gặp lỗi buildpack: `heroku buildpacks:set heroku/ruby`
- Nếu cần restart: `heroku restart`
- Nếu cần xem logs: `heroku logs --tail` 