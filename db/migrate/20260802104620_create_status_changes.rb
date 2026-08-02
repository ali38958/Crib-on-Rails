class CreateStatusChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :status_changes do |t|
      t.references :order, null: false, foreign_key: true
      t.string :old_status
      t.string :new_status
      t.string :changed_by_id
      t.timestamps
    end
  end
end