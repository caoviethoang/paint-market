class ChangeSpreePriceAmountPrecision < ActiveRecord::Migration[8.0]
    def up
    change_column :spree_prices,   :amount,     :decimal, precision: 15, scale: 2
    change_column :spree_variants, :cost_price, :decimal, precision: 15, scale: 2
  end

  def down
    change_column :spree_prices,   :amount,     :decimal, precision: 10, scale: 2
    change_column :spree_variants, :cost_price, :decimal, precision: 10, scale: 2
  end
end
