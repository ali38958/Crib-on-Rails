class AddStatusToPurchases < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :status, :integer, default: 0
  end
end