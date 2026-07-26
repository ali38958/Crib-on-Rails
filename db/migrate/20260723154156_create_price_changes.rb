class CreatePriceChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :price_changes do |t|
      t.references :product, foreign_key: true, null: false
      t.decimal :old_price, precision: 10, scale: 2, null: false
      t.decimal :new_price, precision: 10, scale: 2, null: false
      t.timestamps  # This gives created_at and updated_at
    end
    
    # Add indexes for faster queries
    add_index :price_changes, :created_at
    add_index :price_changes, [:product_id, :created_at]
  end
end