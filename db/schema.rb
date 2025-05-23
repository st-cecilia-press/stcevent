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

ActiveRecord::Schema[8.0].define(version: 2025_05_23_023504) do
  create_table "activities", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.integer "difficulty_id"
    t.text "description"
    t.integer "event_id"
    t.datetime "start_time", precision: nil
    t.integer "classroom_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "activity_type_id"
    t.integer "activity_subtype_id"
    t.integer "duration"
    t.index ["activity_subtype_id"], name: "index_activities_on_activity_subtype_id"
    t.index ["activity_type_id"], name: "index_activities_on_activity_type_id"
    t.index ["classroom_id"], name: "index_activities_on_classroom_id"
    t.index ["difficulty_id"], name: "index_activities_on_difficulty_id"
    t.index ["event_id"], name: "index_activities_on_event_id"
  end

  create_table "activity_subtypes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "activity_types", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "classrooms", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "event_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["event_id"], name: "index_classrooms_on_event_id"
  end

  create_table "difficulties", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "level"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "events", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "short_name"
    t.bigint "schedule_id"
    t.index ["schedule_id"], name: "index_events_on_schedule_id"
  end

  create_table "facilitations", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.bigint "person_id"
    t.integer "activity_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["activity_id"], name: "index_facilitations_on_activity_id"
    t.index ["person_id"], name: "index_facilitations_on_person_id"
  end

  create_table "menu_items", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.integer "order"
    t.string "name"
    t.string "url"
    t.bigint "menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
  end

  create_table "menus", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.integer "order"
    t.string "name"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_menus_on_event_id"
  end

  create_table "pages", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "body", size: :long
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "event_id"
    t.string "slug"
    t.index ["event_id"], name: "index_pages_on_event_id"
  end

  create_table "people", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedule_entries", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "schedule_id", null: false
    t.bigint "activity_id", null: false
    t.bigint "classroom_id", null: false
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_schedule_entries_on_activity_id"
    t.index ["classroom_id"], name: "index_schedule_entries_on_classroom_id"
    t.index ["schedule_id"], name: "index_schedule_entries_on_schedule_id"
  end

  create_table "schedules", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_schedules_on_event_id"
  end

  create_table "staff_members", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "event_id"
    t.bigint "person_id"
    t.integer "staff_role_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["event_id"], name: "index_staff_members_on_event_id"
    t.index ["person_id"], name: "index_staff_members_on_person_id"
    t.index ["staff_role_id"], name: "index_staff_members_on_staff_role_id"
  end

  create_table "staff_roles", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "titles", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

  add_foreign_key "activities", "activity_subtypes"
  add_foreign_key "activities", "activity_types"
  add_foreign_key "activities", "classrooms"
  add_foreign_key "activities", "difficulties"
  add_foreign_key "activities", "events"
  add_foreign_key "classrooms", "events"
  add_foreign_key "events", "schedules"
  add_foreign_key "facilitations", "activities"
  add_foreign_key "facilitations", "people"
  add_foreign_key "pages", "events"
  add_foreign_key "staff_members", "events"
  add_foreign_key "staff_members", "people"
  add_foreign_key "staff_members", "staff_roles"
end
