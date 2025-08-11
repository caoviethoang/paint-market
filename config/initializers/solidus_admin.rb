# frozen_string_literal: true

SolidusAdmin::Config.configure do |config|
  # Path to the logo used in the admin interface.
  #
  # It needs to be a path to an image file accessible by Sprockets.
  # config.logo_path = "my_own_logo.svg"

  # Add custom folder paths to watch for changes to trigger a cache sweep forcing a
  # regeneration of the importmap.
  # config.importmap_cache_sweepers << Rails.root.join("app/javascript/my_admin_components")

  # If you want to avoid defining menu_item customizations twice while migrating to SolidusAdmin
  # you can import menu_items from the backend by uncommenting the following line,
  # but you will need to
  config.import_menu_items_from_backend!

  # Add custom paths to importmap files to be loaded.
  # config.importmap_paths << Rails.root.join("config/solidus_admin_importmap.rb")
  #
  # Configure the main navigation.
  config.menu_items << {
    key: :events,
    route: -> { spree.admin_events_path },
    position: 70
  }
end
