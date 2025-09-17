# frozen_string_literal: true

# Configure SolidusAdmin engine to use app views for overrides
Rails.application.config.after_initialize do
  # Add app views to SolidusAdmin engine view paths
  # This allows view overrides in app/views/spree/admin/ to work in production
  SolidusAdmin::Engine.paths['app/views'] << Rails.root.join('app', 'views')
end
