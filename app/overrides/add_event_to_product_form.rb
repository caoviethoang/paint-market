Deface::Override.new(
  virtual_path: "spree/admin/products/_form",
  name: "add_event_to_product_form",
  insert_after: "[data-hook='admin_product_form_description']",
  text: <<-HTML
    <div data-hook="admin_product_form_event">
      <%= f.label :event_id, "Event" %>
      <%= f.collection_select :event_id, Event.all, :id, :title, include_blank: false %>
    </div>
    <div data-hook="admin_product_form_artist">
      <%= f.label :artist_id, "Artist" %>
      <%= f.collection_select :artist_id, Artist.all, :id, :name, include_blank: false %>
    </div>
  HTML
)
