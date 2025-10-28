class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.references :admin, null: false, foreign_key: true
      t.string :line_user_id, null: false
      t.string :line_display_name
      t.string :real_name

      t.timestamps
    end

    add_index :students, :line_user_id, unique: true
  end
end
