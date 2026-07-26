class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true
      t.decimal :price_per_unit, precision: 10, scale: 2
      t.integer :quantity, null: false
      t.timestamps
    end
    add_index :order_items, [:order_id, :product_id], unique: true
  end
end