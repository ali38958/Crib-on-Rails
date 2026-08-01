class AddColumnsToOrders < ActiveRecord::Migration[7.0]
  def up
    add_column :orders, :created_by_id, :integer unless column_exists?(:orders, :created_by_id)
    add_column :orders, :updated_by_id, :integer unless column_exists?(:orders, :updated_by_id)
    add_column :orders, :price_paid, :decimal, precision: 10, scale: 2 unless column_exists?(:orders, :price_paid)

    add_index :orders, :created_by_id unless index_exists?(:orders, :created_by_id)
    add_index :orders, :updated_by_id unless index_exists?(:orders, :updated_by_id)
  end

  def down
    remove_index :orders, :updated_by_id if index_exists?(:orders, :updated_by_id)
    remove_index :orders, :created_by_id if index_exists?(:orders, :created_by_id)

    remove_column :orders, :price_paid if column_exists?(:orders, :price_paid)
    remove_column :orders, :updated_by_id if column_exists?(:orders, :updated_by_id)
    remove_column :orders, :created_by_id if column_exists?(:orders, :created_by_id)
  end
end