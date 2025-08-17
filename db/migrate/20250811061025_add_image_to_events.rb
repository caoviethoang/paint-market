class AddImageToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :image, :string
    add_column :events, :image_alt, :string
  end
end
