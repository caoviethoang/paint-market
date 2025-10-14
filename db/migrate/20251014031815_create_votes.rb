class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.references :product, null: false, foreign_key: { to_table: :spree_products }
      t.text :comment
      t.integer :star, null: false
      t.string :user_name, null: false
      t.string :user_email, null: false

      t.timestamps
    end

    add_index :votes, :star
    add_index :votes, :user_email
  end
end
