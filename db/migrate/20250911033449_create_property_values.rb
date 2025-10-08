class CreatePropertyValues < ActiveRecord::Migration[8.0]
  def change
    create_table :property_values do |t|
      t.references :property, null: false, foreign_key: { to_table: :spree_properties }
      t.string :value, null: false
      t.string :display_name, null: false
      t.integer :position, default: 0

      t.timestamps
    end
    
    add_index :property_values, [:property_id, :value], unique: true
    add_index :property_values, [:property_id, :position]
  end
end
