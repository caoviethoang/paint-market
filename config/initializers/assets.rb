# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('app', 'javascript')

# Ensure importmap-pinned controllers are compiled and served in production
Rails.application.config.assets.precompile += %w[ application.js ]
Rails.application.config.assets.precompile += Dir.glob(Rails.root.join('app', 'javascript', 'controllers', '**', '*.js'))
  .map { |p| Pathname.new(p).relative_path_from(Rails.root.join('app', 'javascript')).to_s }

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# Configure Sprockets for Solidus compatibility
if ENV['RAILS_ENV'] == 'production'
  # Enable asset precompilation for production with built CSS
  Rails.application.config.assets.compile = false
  Rails.application.config.assets.precompile += %w( tailwind.css )
  Rails.application.config.assets.css_compressor = nil
  Rails.application.config.assets.js_compressor = nil
else
  # Add font paths for development only
  Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets', 'files')
end