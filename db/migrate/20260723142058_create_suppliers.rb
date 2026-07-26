class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.string :name, limit: 50
      t.string :phone, limit: 20
      t.string :email, limit: 50
      t.timestamps
    end
    add_index :suppliers, :email, unique: true
  end
end