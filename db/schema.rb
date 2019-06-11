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

ActiveRecord::Schema.define(version: 20190611120323) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string  "name"
    t.date    "date"
    t.string  "description"
    t.integer "project_id"
    t.string  "url"
    t.date    "end_date"
  end

  add_index "events", ["project_id"], name: "index_events_on_project_id", using: :btree

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
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "latest_status"
    t.integer  "minst_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.date     "date"
    t.string   "meetingtype"
    t.string   "location"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "minutes_url"
  end

  create_table "minsts", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "minsts", ["code"], name: "index_minsts_on_code", using: :btree
  add_index "minsts", ["name"], name: "index_minsts_on_name", using: :btree

  create_table "minutes", force: :cascade do |t|
    t.date     "date"
    t.text     "text"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "item_id"
    t.integer  "meeting_id"
    t.integer  "minst_id"
  end

  add_index "minutes", ["item_id"], name: "index_minutes_on_item_id", using: :btree
  add_index "minutes", ["meeting_id"], name: "index_minutes_on_meeting_id", using: :btree

  create_table "motions", force: :cascade do |t|
    t.integer  "meeting_id"
    t.integer  "project_id"
    t.string   "motion_text"
    t.integer  "number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "motions", ["meeting_id"], name: "index_motions_on_meeting_id", using: :btree
  add_index "motions", ["project_id"], name: "index_motions_on_project_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "affiliation"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "task_group_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "task_group_id"
    t.integer  "base_id"
    t.string   "designation"
    t.string   "title"
    t.string   "short_title"
    t.string   "project_type"
    t.string   "status"
    t.string   "last_motion"
    t.string   "draft_no"
    t.string   "next_action"
    t.date     "pool_formed"
    t.date     "mec"
    t.string   "par_url"
    t.string   "csd_url"
    t.date     "par_approval"
    t.date     "par_expiry"
    t.date     "standard_approval"
    t.date     "published"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "award"
    t.string   "files_url"
    t.string   "draft_url"
    t.string   "page_url"
  end

  add_index "projects", ["base_id"], name: "index_projects_on_base_id", using: :btree
  add_index "projects", ["task_group_id"], name: "index_projects_on_task_group_id", using: :btree

  create_table "requests", force: :cascade do |t|
    t.text     "reqtxt"
    t.integer  "item_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.date     "date"
    t.string   "name"
    t.string   "company"
    t.string   "email"
    t.string   "standard"
    t.string   "clauseno"
    t.string   "clausetitle"
    t.text     "rationale"
    t.text     "proposal"
    t.text     "impact"
  end

  add_index "requests", ["item_id"], name: "index_requests_on_item_id", using: :btree

  create_table "task_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "person_id"
    t.integer  "chair_id"
    t.string   "abbrev"
    t.string   "page_url"
  end

  add_index "task_groups", ["chair_id"], name: "index_task_groups_on_chair_id", using: :btree
  add_index "task_groups", ["person_id"], name: "index_task_groups_on_person_id", using: :btree

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

  add_foreign_key "events", "projects"
  add_foreign_key "minutes", "items"
  add_foreign_key "minutes", "meetings"
  add_foreign_key "motions", "meetings"
  add_foreign_key "motions", "projects"
  add_foreign_key "people", "task_groups"
  add_foreign_key "projects", "task_groups"
  add_foreign_key "requests", "items"
  add_foreign_key "task_groups", "people"
end
