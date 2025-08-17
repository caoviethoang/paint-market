Deface::Override.new(
  virtual_path: "spree/layouts/admin",
  name: "add_taxonomies_to_admin_menu",
  insert_bottom: "[data-hook='admin_tabs']",
  text: "<%= tab :taxonomies, url: spree.admin_taxonomies_path, icon: 'tags' %>"
) 