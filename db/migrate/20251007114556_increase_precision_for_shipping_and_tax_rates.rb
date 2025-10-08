class IncreasePrecisionForShippingAndTaxRates < ActiveRecord::Migration[8.0]
  def up
    change_column :spree_shipping_rates, :cost, :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_shipping_rate_taxes, :amount, :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_tax_rates, :amount, :decimal, precision: 15, scale: 5
  end

  def down
    change_column :spree_shipping_rates, :cost, :decimal, precision: 8, scale: 2, default: "0.0"
    change_column :spree_shipping_rate_taxes, :amount, :decimal, precision: 8, scale: 2, default: "0.0"
    change_column :spree_tax_rates, :amount, :decimal, precision: 8, scale: 5
  end
end
