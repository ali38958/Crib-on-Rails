class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.references :supplier, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :quantity, default: 0
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.timestamps
    end
    add_index :purchases, [:supplier_id, :product_id]
  end
end