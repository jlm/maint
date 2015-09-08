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

ActiveRecord::Schema.define(version: 20150908054104) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "imports", force: :cascade do |t|
    t.string   "filename"
    t.boolean  "imported"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "content_type"
  end

  create_table "items", force: :cascade do |t|
    t.string   "number"
    t.date     "date"
    t.string   "standard"
    t.string   "clause"
    t.text     "subject"
    t.string   "draft"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "minuteable_id"
    t.string   "minuteable_type"
    t.string   "latest_status"
  end

  add_index "items", ["minuteable_id"], name: "index_items_on_minuteable_id", using: :btree

  create_table "meetings", force: :cascade do |t|
    t.date     "date"
    t.string   "meetingtype"
    t.string   "location"
    t.integer  "minuteable_id"
    t.string   "minuteable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "meetings", ["minuteable_id"], name: "index_meetings_on_minuteable_id", using: :btree

  create_table "meetings_minutes", id: false, force: :cascade do |t|
    t.integer "meeting_id"
    t.integer "minute_id"
  end

  add_index "meetings_minutes", ["meeting_id", "minute_id"], name: "index_meetings_minutes_on_meeting_id_and_minute_id", using: :btree
  add_index "meetings_minutes", ["minute_id"], name: "index_meetings_minutes_on_minute_id", using: :btree

  create_table "minutes", force: :cascade do |t|
    t.date     "date"
    t.text     "text"
    t.string   "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "minuteable_id"
    t.string   "minuteable_type"
  end

  add_index "minutes", ["minuteable_type", "minuteable_id"], name: "index_minutes_on_minuteable_type_and_minuteable_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                  default: false
    t.boolean  "debugger",               default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
