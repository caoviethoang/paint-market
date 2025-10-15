class AddViewsCountToSpreeProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :spree_products, :views_count, :integer, default: 0, null: false
  end
end
