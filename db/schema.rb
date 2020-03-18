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

ActiveRecord::Schema.define(version: 0) do

  create_table "areas", force: :cascade do |t|
    t.integer "organization_id", limit: 4
    t.string  "name",            limit: 255
  end

  add_index "areas", ["organization_id"], name: "organization_id", using: :btree

  create_table "areas_profiles", id: false, force: :cascade do |t|
    t.integer "area_id",    limit: 4, null: false
    t.integer "profile_id", limit: 4, null: false
  end

  add_index "areas_profiles", ["area_id"], name: "area_id", using: :btree
  add_index "areas_profiles", ["profile_id"], name: "profile_id", using: :btree

  create_table "areas_supervisors", id: false, force: :cascade do |t|
    t.integer "area_id", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
  end

  add_index "areas_supervisors", ["area_id"], name: "area_id", using: :btree
  add_index "areas_supervisors", ["user_id"], name: "user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string "name",       limit: 255
    t.text   "descrition", limit: 65535
  end

  create_table "organizations_secretaries", id: false, force: :cascade do |t|
    t.integer "organization_id", limit: 4, null: false
    t.integer "user_id",         limit: 4, null: false
  end

  add_index "organizations_secretaries", ["organization_id"], name: "organization_id", using: :btree
  add_index "organizations_secretaries", ["user_id"], name: "user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer "organization_id", limit: 4
    t.integer "student_id",      limit: 4
    t.integer "round_id",        limit: 4
    t.text    "general_notes",   limit: 65535
    t.text    "area_notes",      limit: 65535
    t.boolean "done",            limit: 1
    t.boolean "punchable",       limit: 1
    t.boolean "resign",          limit: 1
  end

  add_index "profiles", ["organization_id"], name: "organization_id", using: :btree
  add_index "profiles", ["round_id"], name: "round_id", using: :btree
  add_index "profiles", ["student_id"], name: "student_id", using: :btree

  create_table "punches", force: :cascade do |t|
    t.integer  "profile_id",   limit: 4
    t.datetime "arrival"
    t.string   "arrival_ip",   limit: 20
    t.datetime "departure"
    t.string   "departure_ip", limit: 20
    t.text     "note",         limit: 65535
  end

  add_index "punches", ["profile_id"], name: "profile_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.date    "start_date"
    t.date    "end_date"
    t.boolean "active",     limit: 1
  end

  create_table "users", force: :cascade do |t|
    t.string "upn",            limit: 255
    t.string "name",           limit: 255
    t.string "surname",        limit: 255
    t.string "email",          limit: 255
    t.string "telephone",      limit: 100
    t.date   "updated_at"
    t.string "type",           limit: 7
    t.string "employeeNumber", limit: 10
  end

  add_foreign_key "areas_profiles", "areas", name: "areas_profiles_ibfk_1"
  add_foreign_key "areas_profiles", "profiles", name: "areas_profiles_ibfk_2"
  add_foreign_key "areas_supervisors", "areas", name: "areas_supervisors_ibfk_1"
  add_foreign_key "areas_supervisors", "users", name: "areas_supervisors_ibfk_2"
  add_foreign_key "organizations_secretaries", "organizations", name: "organizations_secretaries_ibfk_1"
  add_foreign_key "organizations_secretaries", "users", name: "organizations_secretaries_ibfk_2"
  add_foreign_key "profiles", "rounds", name: "profiles_ibfk_2"
  add_foreign_key "profiles", "users", column: "student_id", name: "profiles_ibfk_1"
  add_foreign_key "punches", "profiles", name: "punches_ibfk_1"
end
