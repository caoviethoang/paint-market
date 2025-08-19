# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Disable asset precompilation for Heroku to avoid SassC issues
if ENV['RAILS_ENV'] == 'production'
  Rails.application.config.assets.compile = false
  Rails.application.config.assets.precompile = []
  Rails.application.config.assets.css_compressor = nil
  Rails.application.config.assets.js_compressor = nil
end

# Add font paths for development only
if ENV['RAILS_ENV'] != 'production'
  Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets', 'fonts')
end