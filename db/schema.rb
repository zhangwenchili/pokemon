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

ActiveRecord::Schema[8.1].define(version: 2026_04_04_185106) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "instance_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "hit_point"
    t.bigint "instance_id", null: false
    t.datetime "updated_at", null: false
    t.index ["instance_id"], name: "index_instance_statuses_on_instance_id"
  end

  create_table "instances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "level"
    t.string "nickname"
    t.bigint "species_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["species_id"], name: "index_instances_on_species_id"
    t.index ["user_id"], name: "index_instances_on_user_id"
  end

  create_table "species", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "species_type_maps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "species_id", null: false
    t.bigint "type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["species_id"], name: "index_species_type_maps_on_species_id"
    t.index ["type_id"], name: "index_species_type_maps_on_type_id"
  end

  create_table "types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "user_team_slots", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "instance_id", null: false
    t.integer "slot_index"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["instance_id"], name: "index_user_team_slots_on_instance_id"
    t.index ["user_id"], name: "index_user_team_slots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "instance_statuses", "instances"
  add_foreign_key "instances", "species"
  add_foreign_key "instances", "users"
  add_foreign_key "species_type_maps", "species"
  add_foreign_key "species_type_maps", "types"
  add_foreign_key "user_team_slots", "instances"
  add_foreign_key "user_team_slots", "users"
end
