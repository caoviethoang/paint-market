class CreateArtist < ActiveRecord::Migration[8.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.text :introduction
      t.date :dob
      t.string :address
      t.date :start_work

      t.timestamps
    end
  end
end
