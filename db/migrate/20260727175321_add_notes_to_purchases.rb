class AddNotesToPurchases < ActiveRecord::Migration[7.0]
  def change
    add_column :purchases, :notes, :text
  end
end