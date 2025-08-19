#!/bin/bash

# Script deploy tự động cho Heroku
# Sử dụng: ./deploy.sh [app-name]

set -e

APP_NAME=${1:-"paint-market"}

echo "🚀 Bắt đầu deploy ứng dụng $APP_NAME lên Heroku..."

# Kiểm tra xem có đang ở trong git repository không
if [ ! -d ".git" ]; then
    echo "❌ Lỗi: Không tìm thấy git repository. Hãy chạy script này trong thư mục dự án."
    exit 1
fi

# Kiểm tra xem có Heroku CLI không
if ! command -v heroku &> /dev/null; then
    echo "❌ Lỗi: Không tìm thấy Heroku CLI. Hãy cài đặt từ: https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Kiểm tra xem có đăng nhập Heroku không
if ! heroku auth:whoami &> /dev/null; then
    echo "🔐 Vui lòng đăng nhập vào Heroku..."
    heroku login
fi

# Kiểm tra xem app có tồn tại không
if ! heroku apps:info --app $APP_NAME &> /dev/null; then
    echo "📱 Tạo ứng dụng mới: $APP_NAME"
    heroku create $APP_NAME
else
    echo "✅ Ứng dụng $APP_NAME đã tồn tại"
fi

# Thêm PostgreSQL addon nếu chưa có
if ! heroku addons:info --app $APP_NAME | grep -q "heroku-postgresql"; then
    echo "🗄️ Thêm PostgreSQL addon..."
    heroku addons:create heroku-postgresql:mini --app $APP_NAME
else
    echo "✅ PostgreSQL addon đã tồn tại"
fi

# Thêm Redis addon nếu chưa có
if ! heroku addons:info --app $APP_NAME | grep -q "heroku-redis"; then
    echo "🔴 Thêm Redis addon..."
    heroku addons:create heroku-redis:mini --app $APP_NAME
else
    echo "✅ Redis addon đã tồn tại"
fi

# Cấu hình environment variables
echo "⚙️ Cấu hình environment variables..."

# Rails master key
if [ -f "config/master.key" ]; then
    MASTER_KEY=$(cat config/master.key)
    heroku config:set RAILS_MASTER_KEY=$MASTER_KEY --app $APP_NAME
    echo "✅ Đã set RAILS_MASTER_KEY"
else
    echo "⚠️ Cảnh báo: Không tìm thấy config/master.key"
    echo "Hãy chạy: rails credentials:edit để tạo master key"
fi

# Các biến môi trường cơ bản
heroku config:set RAILS_ENV=production --app $APP_NAME
heroku config:set RAILS_SERVE_STATIC_FILES=true --app $APP_NAME
heroku config:set RAILS_LOG_TO_STDOUT=true --app $APP_NAME

echo "✅ Đã cấu hình environment variables cơ bản"

# Commit và push code
echo "📤 Push code lên Heroku..."
git add .
git commit -m "Deploy to Heroku - $(date)" || echo "Không có thay đổi để commit"
git push heroku main || git push heroku master

# Chạy database migrations
echo "🗄️ Chạy database migrations..."
heroku run rails db:migrate --app $APP_NAME

# Mở ứng dụng
echo "🌐 Mở ứng dụng..."
heroku open --app $APP_NAME

echo "🎉 Deploy hoàn tất! Ứng dụng của bạn đã được deploy lên Heroku."
echo "📊 Để xem logs: heroku logs --tail --app $APP_NAME"
echo "⚙️ Để xem config: heroku config --app $APP_NAME"
