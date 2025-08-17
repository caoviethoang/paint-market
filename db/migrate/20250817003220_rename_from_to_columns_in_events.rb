class RenameFromToColumnsInEvents < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :from, :start_time
    rename_column :events, :to, :end_time
  end
end
