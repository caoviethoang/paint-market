class RenameAddressToLocationInEvents < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :address, :location
  end
end
