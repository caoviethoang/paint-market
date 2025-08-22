class UpdateArtistProductsForeignKey < ActiveRecord::Migration[7.2]
  def change
    # Xóa foreign key constraint cũ (nếu có)
    if foreign_key_exists?(:spree_products, :artists)
      remove_foreign_key :spree_products, :artists
    end
    
    # Thêm foreign key constraint mới với ON DELETE SET NULL
    add_foreign_key :spree_products, :artists, on_delete: :nullify
    
    # Đảm bảo có index cho artist_id (nếu chưa có)
    unless index_exists?(:spree_products, :artist_id)
      add_index :spree_products, :artist_id
    end
  end
end
