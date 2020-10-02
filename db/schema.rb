# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "areas", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.string "name"
    t.index ["organization_id"], name: "organization_id"
  end

  create_table "areas_profiles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "area_id", null: false, unsigned: true
    t.integer "profile_id", null: false, unsigned: true
    t.index ["area_id"], name: "area_id"
    t.index ["profile_id"], name: "profile_id"
  end

  create_table "areas_supervisors", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "area_id", null: false, unsigned: true
    t.integer "user_id", null: false, unsigned: true
    t.index ["area_id"], name: "area_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "organizations", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
  end

  create_table "permissions", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false, unsigned: true
    t.integer "organization_id", null: false, unsigned: true
    t.integer "authlevel"
    t.index ["organization_id"], name: "fk_organization_permission"
    t.index ["user_id"], name: "fk_user_permission"
  end

  create_table "profiles", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.integer "student_id", unsigned: true
    t.integer "round_id", unsigned: true
    t.text "general_notes"
    t.text "area_notes"
    t.boolean "done"
    t.boolean "punchable"
    t.boolean "resign"
    t.index ["organization_id"], name: "organization_id"
    t.index ["round_id"], name: "round_id"
    t.index ["student_id"], name: "student_id"
  end

  create_table "punches", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "profile_id", unsigned: true
    t.datetime "arrival"
    t.string "arrival_ip", limit: 20
    t.datetime "departure"
    t.string "departure_ip", limit: 20
    t.text "note"
    t.index ["profile_id"], name: "profile_id"
  end

  create_table "rounds", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.boolean "active"
  end

  create_table "users", id: :integer, unsigned: true, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "upn"
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "telephone", limit: 100
    t.date "updated_at"
    t.column "type", "enum('Student')"
    t.string "employeeNumber", limit: 10
  end

  add_foreign_key "areas_profiles", "areas", name: "areas_profiles_ibfk_1"
  add_foreign_key "areas_profiles", "profiles", name: "areas_profiles_ibfk_2"
  add_foreign_key "areas_supervisors", "areas", name: "areas_supervisors_ibfk_1"
  add_foreign_key "areas_supervisors", "users", name: "areas_supervisors_ibfk_2"
  add_foreign_key "permissions", "organizations", name: "fk_organization_permission"
  add_foreign_key "permissions", "users", name: "fk_user_permission"
  add_foreign_key "profiles", "rounds", name: "profiles_ibfk_2"
  add_foreign_key "profiles", "users", column: "student_id", name: "profiles_ibfk_1"
  add_foreign_key "punches", "profiles", name: "punches_ibfk_1"
end
