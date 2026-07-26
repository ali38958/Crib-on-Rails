class AddPasswordDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    # Rename password to password_digest for all 3 tables
    rename_column :admins, :password, :password_digest
    rename_column :order_receivers, :password, :password_digest
    rename_column :stock_managers, :password, :password_digest
  end
end