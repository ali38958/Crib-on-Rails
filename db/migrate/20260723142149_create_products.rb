class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, limit: 100
      t.references :category, foreign_key: true
      t.integer :quantity, default: 0
      t.decimal :current_price, precision: 10, scale: 2, default: 0.00
      t.string :image_url, limit: 100
      t.timestamps
    end
    add_index :products, :name
  end
end