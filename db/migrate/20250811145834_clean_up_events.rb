class CleanUpEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :from, :datetime
    add_column :events, :to, :datetime
    add_column :events, :address, :string
  end
end
