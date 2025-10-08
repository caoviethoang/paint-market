# config/initializers/assets.rb
Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.paths << Rails.root.join('app', 'javascript')

# CHỈ precompile application.js và CSS
Rails.application.config.assets.precompile += %w[ application.js ]

if ENV['RAILS_ENV'] == 'production'
  Rails.application.config.assets.compile = false
  Rails.application.config.assets.precompile += %w( tailwind.css )
  Rails.application.config.assets.css_compressor = nil
  Rails.application.config.assets.js_compressor = nil
else
  Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets', 'files')
end
