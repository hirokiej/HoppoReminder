class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.references :student, null: false, foreign_key: true
      t.string :summary, null: false
      t.string :google_event_id, null: false
      t.datetime :start_at, null: false

      t.timestamps
    end
    add_index :schedules, :google_event_id, unique: true
  end
end
