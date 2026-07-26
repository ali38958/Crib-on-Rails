class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :name, limit: 50
      t.string :phone, limit: 20
      t.string :email, limit: 50
      t.text :location
      t.timestamps
    end
    add_index :customers, :email, unique: true
  end
end