# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160529163243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.float    "value"
    t.datetime "capture_time"
    t.boolean  "notified"
    t.integer  "sensor_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "events", ["sensor_id"], name: "index_events_on_sensor_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "images", ["event_id"], name: "index_images_on_event_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "kind"
    t.string   "address"
    t.integer  "sensor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notifications", ["sensor_id"], name: "index_notifications_on_sensor_id", using: :btree

  create_table "sensors", force: :cascade do |t|
    t.string   "name"
    t.integer  "unit"
    t.integer  "kind"
    t.boolean  "public"
    t.integer  "type_of_graph"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "notification"
    t.integer  "notification_value"
    t.integer  "notification_count"
    t.datetime "notification_window"
  end

  add_index "sensors", ["user_id"], name: "index_sensors_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "last_notified"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "api_key"
    t.string   "phone_number"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "events", "sensors"
  add_foreign_key "images", "events"
  add_foreign_key "notes", "users"
  add_foreign_key "notifications", "sensors"
  add_foreign_key "sensors", "users"
end
