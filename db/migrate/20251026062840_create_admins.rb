class CreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email, null: false
      t.string :line_channel_id
      t.string :line_channel_secret
      t.string :line_channel_access_token
      t.string :google_token
      t.string :google_refresh_token

      t.timestamps
    end
    add_index :admins, :email, unique: true
    add_index :admins, :line_channel_id, unique: true
  end
end
