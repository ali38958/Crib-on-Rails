class ChangeCreatedByUpdatedByToString < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :created_by_id, :string
    change_column :orders, :updated_by_id, :string
  end
end