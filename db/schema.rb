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

ActiveRecord::Schema[8.0].define(version: 2025_03_25_231932) do
  create_table "activities", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "title"
    t.bigint "difficulty_id"
    t.text "description"
    t.bigint "event_id"
    t.datetime "start_time"
    t.bigint "classroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "activity_type_id"
    t.bigint "activity_subtype_id"
    t.integer "duration"
    t.index ["activity_subtype_id"], name: "index_activities_on_activity_subtype_id"
    t.index ["activity_type_id"], name: "index_activities_on_activity_type_id"
    t.index ["classroom_id"], name: "index_activities_on_classroom_id"
    t.index ["difficulty_id"], name: "index_activities_on_difficulty_id"
    t.index ["event_id"], name: "index_activities_on_event_id"
  end

  create_table "activity_subtypes", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activity_types", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classrooms", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_classrooms_on_event_id"
  end

  create_table "difficulties", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.integer "level"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_items", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.integer "order"
    t.text "name"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_menu_items_on_event_id"
  end

  create_table "pages", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "body", size: :long
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "event_id"
    t.string "slug"
    t.bigint "menu_item_id"
    t.integer "menu_order"
    t.index ["menu_item_id"], name: "index_pages_on_menu_item_id"
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

  create_table "people", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "sca_name"
    t.text "bio"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "facilitators", force: :cascade do |t|
    t.bigint  "person_id"
    t.bigint  "activity_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "facilitators", ["activity_id"], name: "index_facilitators_on_activity_id", using: :btree
  add_index "facilitators", ["person_id"], name: "index_facilitators_on_person_id", using: :btree

  add_foreign_key "activities", "activity_subtypes"
  add_foreign_key "activities", "activity_types"
  add_foreign_key "activities", "classrooms"
  add_foreign_key "activities", "difficulties"
  add_foreign_key "activities", "events"
  add_foreign_key "classrooms", "events"
  add_foreign_key "menu_items", "events"
  add_foreign_key "pages", "menu_items"
  add_foreign_key "facilitators", "activities"
  add_foreign_key "facilitators", "people"
end
