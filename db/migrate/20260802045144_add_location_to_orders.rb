class AddLocationToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :location, :string
  end
end