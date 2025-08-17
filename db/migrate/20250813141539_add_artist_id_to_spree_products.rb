class AddArtistIdToSpreeProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :spree_products, :artist, foreign_key: true, null: true
  end
end
