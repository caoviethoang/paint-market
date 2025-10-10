# config/initializers/assets.rb
Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.paths << Rails.root.join('app', 'javascript')

# Precompile các file cần thiết
Rails.application.config.assets.precompile += %w[ application.js tailwind.css ]

# Chỉ thêm path cho development
unless Rails.env.production?
  Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets', 'files')
end
