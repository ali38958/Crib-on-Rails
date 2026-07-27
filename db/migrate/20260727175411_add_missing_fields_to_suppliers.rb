class AddMissingFieldsToSuppliers < ActiveRecord::Migration[7.0]
  def change
    add_column :suppliers, :contact_person, :string unless column_exists?(:suppliers, :contact_person)
    add_column :suppliers, :address, :text unless column_exists?(:suppliers, :address)
    add_column :suppliers, :tax_id, :string unless column_exists?(:suppliers, :tax_id)
    # phone already exists, so skip it
  end
end