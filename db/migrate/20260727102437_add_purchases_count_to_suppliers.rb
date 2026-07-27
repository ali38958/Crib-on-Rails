class AddPurchasesCountToSuppliers < ActiveRecord::Migration[7.0]
  def change
    add_column :suppliers, :purchases_count, :integer, default: 0
  end
end