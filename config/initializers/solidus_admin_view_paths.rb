# frozen_string_literal: true

# Configure SolidusAdmin engine to use app views for overrides
# This allows view overrides in app/views/spree/admin/ to work in production

# Method 1: Add to SolidusAdmin engine view paths
SolidusAdmin::Engine.paths['app/views'] << Rails.root.join('app', 'views')

# Method 2: Also add to SolidusAdmin engine view_paths if it exists
if SolidusAdmin::Engine.respond_to?(:view_paths)
  SolidusAdmin::Engine.view_paths << Rails.root.join('app', 'views')
end

# Method 3: Override the view_paths method
module SolidusAdmin
  class Engine < ::Rails::Engine
    def view_paths
      @view_paths ||= begin
        paths = super
        paths.unshift(Rails.root.join('app', 'views'))
        paths
      end
    end
  end
end
