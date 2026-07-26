class CreateOrderReceivers < ActiveRecord::Migration[7.0]
  def change
    create_table :order_receivers, id: false do |t|
      t.string :id, primary_key: true, limit: 50
      t.string :name, null: false, limit: 50
      t.string :phone, limit: 50
      t.string :email, limit: 50
      t.string :password, limit: 255
      t.timestamps
    end
    add_index :order_receivers, :email, unique: true
  end
end