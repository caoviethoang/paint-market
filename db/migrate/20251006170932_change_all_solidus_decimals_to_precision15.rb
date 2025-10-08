class ChangeAllSolidusDecimalsToPrecision15 < ActiveRecord::Migration[8.0]
  def up
    # spree_line_items
    change_column :spree_line_items, :price,                :decimal, precision: 15, scale: 2, null: false
    change_column :spree_line_items, :cost_price,           :decimal, precision: 15, scale: 2
    change_column :spree_line_items, :adjustment_total,     :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_line_items, :additional_tax_total, :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_line_items, :promo_total,          :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_line_items, :included_tax_total,   :decimal, precision: 15, scale: 2, default: "0.0", null: false

    # spree_orders
    change_column :spree_orders, :item_total,          :decimal, precision: 15, scale: 2, default: "0.0", null: false
    change_column :spree_orders, :total,               :decimal, precision: 15, scale: 2, default: "0.0", null: false
    change_column :spree_orders, :adjustment_total,    :decimal, precision: 15, scale: 2, default: "0.0", null: false
    change_column :spree_orders, :payment_total,       :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_orders, :shipment_total,      :decimal, precision: 15, scale: 2, default: "0.0", null: false
    change_column :spree_orders, :additional_tax_total, :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_orders, :promo_total,         :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_orders, :included_tax_total,  :decimal, precision: 15, scale: 2, default: "0.0", null: false

    # spree_shipments
    change_column :spree_shipments, :cost,                :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_shipments, :adjustment_total,    :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_shipments, :additional_tax_total, :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_shipments, :promo_total,         :decimal, precision: 15, scale: 2, default: "0.0"
    change_column :spree_shipments, :included_tax_total,  :decimal, precision: 15, scale: 2, default: "0.0", null: false

    # spree_adjustments
    change_column :spree_adjustments, :amount, :decimal, precision: 15, scale: 2
  end

  def down
    # rollback về 10,2 nếu cần
    change_column :spree_line_items, :price,                :decimal, precision: 10, scale: 2, null: false
    change_column :spree_line_items, :cost_price,           :decimal, precision: 10, scale: 2
    change_column :spree_line_items, :adjustment_total,     :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_line_items, :additional_tax_total, :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_line_items, :promo_total,          :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_line_items, :included_tax_total,   :decimal, precision: 10, scale: 2, default: "0.0", null: false

    change_column :spree_orders, :item_total,          :decimal, precision: 10, scale: 2, default: "0.0", null: false
    change_column :spree_orders, :total,               :decimal, precision: 10, scale: 2, default: "0.0", null: false
    change_column :spree_orders, :adjustment_total,    :decimal, precision: 10, scale: 2, default: "0.0", null: false
    change_column :spree_orders, :payment_total,       :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_orders, :shipment_total,      :decimal, precision: 10, scale: 2, default: "0.0", null: false
    change_column :spree_orders, :additional_tax_total, :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_orders, :promo_total,         :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_orders, :included_tax_total,  :decimal, precision: 10, scale: 2, default: "0.0", null: false

    change_column :spree_shipments, :cost,                :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_shipments, :adjustment_total,    :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_shipments, :additional_tax_total, :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_shipments, :promo_total,         :decimal, precision: 10, scale: 2, default: "0.0"
    change_column :spree_shipments, :included_tax_total,  :decimal, precision: 10, scale: 2, default: "0.0", null: false

    change_column :spree_adjustments, :amount, :decimal, precision: 10, scale: 2
  end
end
