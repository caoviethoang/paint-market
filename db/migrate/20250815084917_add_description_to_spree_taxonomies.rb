class AddDescriptionToSpreeTaxonomies < ActiveRecord::Migration[8.0]
  def change
    add_column :spree_taxonomies, :description, :text
  end
end
