class AddColumnsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :created_by_id, :integer
    add_column :orders, :updated_by_id, :integer
    add_column :orders, :price_paid, :decimal, precision: 10, scale: 2
    add_index :orders, :created_by_id
    add_index :orders, :updated_by_id
    # Optional: foreign key constraints if you want
    add_foreign_key :orders, :order_receivers, column: :created_by_id
    add_foreign_key :orders, :order_receivers, column: :updated_by_id
  end
end