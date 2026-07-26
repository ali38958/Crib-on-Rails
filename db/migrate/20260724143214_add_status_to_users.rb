class AddStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :status, :integer, default: 1
    add_column :stock_managers, :status, :integer, default: 1
    add_column :order_receivers, :status, :integer, default: 1
  end
end