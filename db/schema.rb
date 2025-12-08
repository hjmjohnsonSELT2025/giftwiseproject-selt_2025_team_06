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

ActiveRecord::Schema[7.1].define(version: 2025_12_08_202646) do
  create_table "events", force: :cascade do |t|
    t.string "title"
    t.date "event_date"
    t.string "location"
    t.decimal "budget", precision: 10, scale: 2
    t.string "theme"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "host_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "gift_givers", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recipient_id"
    t.integer "gift_id"
    t.index ["event_id"], name: "index_gift_givers_on_event_id"
    t.index ["user_id"], name: "index_gift_givers_on_user_id"
  end

  create_table "gift_statuses", force: :cascade do |t|
    t.string "status_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gifts", force: :cascade do |t|
    t.string "name", null: false
    t.float "price"
    t.text "purchase_url"
    t.text "description"
    t.integer "upvotes", default: 0
    t.integer "status_id", null: false
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_gifts_on_creator_id"
    t.index ["status_id"], name: "index_gifts_on_status_id"
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

  create_table "user_gift_statuses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "gift_id", null: false
    t.integer "status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gift_id"], name: "index_user_gift_statuses_on_gift_id"
    t.index ["status_id"], name: "index_user_gift_statuses_on_status_id"
    t.index ["user_id", "gift_id"], name: "index_user_gift_statuses_on_user_id_and_gift_id", unique: true
    t.index ["user_id"], name: "index_user_gift_statuses_on_user_id"
  end

  create_table "user_gift_votes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "gift_id", null: false
    t.integer "vote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gift_id"], name: "index_user_gift_votes_on_gift_id"
    t.index ["user_id", "gift_id"], name: "index_user_gift_votes_on_user_id_and_gift_id", unique: true
    t.index ["user_id"], name: "index_user_gift_votes_on_user_id"
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
    t.string "reset_token"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "events", "users"
  add_foreign_key "gift_givers", "events"
  add_foreign_key "gift_givers", "gifts"
  add_foreign_key "gift_givers", "users"
  add_foreign_key "gift_givers", "users", column: "recipient_id"
  add_foreign_key "gifts", "gift_statuses", column: "status_id"
  add_foreign_key "gifts", "users", column: "creator_id"
  add_foreign_key "invites", "events"
  add_foreign_key "invites", "users"
  add_foreign_key "user_gift_statuses", "gift_statuses", column: "status_id"
  add_foreign_key "user_gift_statuses", "gifts"
  add_foreign_key "user_gift_statuses", "users"
  add_foreign_key "user_gift_votes", "gifts"
  add_foreign_key "user_gift_votes", "users"
  add_foreign_key "user_preferences", "preferences"
  add_foreign_key "user_preferences", "users"
end
