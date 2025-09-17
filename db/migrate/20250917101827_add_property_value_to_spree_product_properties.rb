class AddPropertyValueToSpreeProductProperties < ActiveRecord::Migration[8.0]
  def change
    add_reference :spree_product_properties, :property_value, index: true, foreign_key: { to_table: :property_values }
  end
end
