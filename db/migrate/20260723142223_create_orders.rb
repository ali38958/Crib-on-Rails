class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :customer, foreign_key: true
      t.decimal :price_paid, precision: 10, scale: 2
      t.decimal :total_price, precision: 10, scale: 2
      t.integer :status, default: 0  # 0=pending, 1=confirmed, etc.
      t.timestamps
    end
    add_index :orders, :status
    add_index :orders, :created_at
  end
end