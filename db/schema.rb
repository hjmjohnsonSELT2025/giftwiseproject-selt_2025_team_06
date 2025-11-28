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

ActiveRecord::Schema[7.1].define(version: 2025_11_28_192836) do
  create_table "events", force: :cascade do |t|
    t.string "title"
    t.date "event_date"
    t.string "location"
    t.decimal "budget", precision: 10, scale: 2
    t.string "theme"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "gift_givers", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "user_id", null: false
    t.text "recipients", default: "[]"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_gift_givers_on_event_id"
    t.index ["user_id"], name: "index_gift_givers_on_user_id"
  end

  create_table "invites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "event_id", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_invites_on_event_id"
    t.index ["user_id"], name: "index_invites_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_preferences_on_name", unique: true
  end

  create_table "user_preferences", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "preference_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: "like", null: false
    t.index ["preference_id"], name: "index_user_preferences_on_preference_id"
    t.index ["user_id", "preference_id"], name: "index_user_preferences_on_user_id_and_preference_id", unique: true
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "username", null: false
    t.string "password_digest", null: false
    t.text "likes", default: "[]"
    t.text "dislikes", default: "[]"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hobbies"
    t.string "occupation"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "events", "users"
  add_foreign_key "gift_givers", "events"
  add_foreign_key "gift_givers", "users"
  add_foreign_key "invites", "events"
  add_foreign_key "invites", "users"
  add_foreign_key "user_preferences", "preferences"
  add_foreign_key "user_preferences", "users"
end
