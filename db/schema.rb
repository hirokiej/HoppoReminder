# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_10_081425) do
  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "google_refresh_token"
    t.string "google_token"
    t.string "line_channel_access_token"
    t.string "line_channel_id"
    t.string "line_channel_secret"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["line_channel_id"], name: "index_admins_on_line_channel_id", unique: true
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "google_event_id", null: false
    t.datetime "start_at", null: false
    t.integer "student_id", null: false
    t.string "summary", null: false
    t.datetime "updated_at", null: false
    t.index ["google_event_id"], name: "index_schedules_on_google_event_id", unique: true
    t.index ["student_id"], name: "index_schedules_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.string "line_display_name"
    t.string "line_user_id", null: false
    t.string "real_name"
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_students_on_admin_id"
    t.index ["line_user_id"], name: "index_students_on_line_user_id", unique: true
  end

  add_foreign_key "schedules", "students"
  add_foreign_key "students", "admins"
end
