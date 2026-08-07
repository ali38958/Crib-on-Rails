class CreatePasswordResets < ActiveRecord::Migration[8.1]
  def change
    create_table :password_resets do |t|
      t.string :user_type, null: false
      t.string :user_id, null: false
      t.string :otp_digest, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
    add_index :password_resets, [:user_type, :user_id]
  end
end
