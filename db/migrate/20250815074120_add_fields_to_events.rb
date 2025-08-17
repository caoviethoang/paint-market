class AddFieldsToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :statement, :string
    add_column :events, :gallery, :string
    add_column :events, :press_release, :string
  end
end
