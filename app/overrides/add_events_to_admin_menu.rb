Deface::Override.new(
  virtual_path: "spree/layouts/admin",
  name: "add_events_to_admin_menu",
  insert_bottom: "[data-hook='admin_tabs']",
  text: "<%= tab :events, url: spree.admin_events_path, icon: 'calendar' %>"
)
