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

ActiveRecord::Schema.define(version: 20160517174317) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: :cascade do |t|
    t.string  "text_id",   null: false
    t.string  "name",      null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.decimal "elevation"
    t.index ["text_id"], name: "index_locations_on_text_id", unique: true, using: :btree
  end

  create_table "measurements", force: :cascade do |t|
    t.integer  "series_id",   null: false
    t.integer  "snapshot_id", null: false
    t.datetime "created_at",  null: false
    t.decimal  "value",       null: false
    t.index ["series_id", "created_at"], name: "index_measurements_on_series_id_and_created_at", unique: true, using: :btree
    t.index ["series_id"], name: "index_measurements_on_series_id", using: :btree
    t.index ["snapshot_id"], name: "index_measurements_on_snapshot_id", using: :btree
  end

  create_table "properties", force: :cascade do |t|
    t.string "text_id", null: false
    t.string "name",    null: false
    t.string "unit",    null: false
    t.index ["text_id", "unit"], name: "index_properties_on_text_id_and_unit", unique: true, using: :btree
  end

  create_table "series", force: :cascade do |t|
    t.integer "source_id",   null: false
    t.integer "location_id", null: false
    t.integer "property_id", null: false
    t.index ["location_id"], name: "index_series_on_location_id", using: :btree
    t.index ["property_id"], name: "index_series_on_property_id", using: :btree
    t.index ["source_id", "location_id", "property_id"], name: "index_series_on_source_id_and_location_id_and_property_id", unique: true, using: :btree
    t.index ["source_id"], name: "index_series_on_source_id", using: :btree
  end

# Could not dump table "snapshots" because of following StandardError
#   Unknown type 'snapshot_status' for column 'status'

  create_table "sources", force: :cascade do |t|
    t.string "text_id", null: false
    t.string "name",    null: false
    t.json   "config"
    t.index ["text_id"], name: "index_sources_on_text_id", unique: true, using: :btree
  end

  add_foreign_key "measurements", "series"
  add_foreign_key "measurements", "snapshots"
  add_foreign_key "series", "locations"
  add_foreign_key "series", "properties"
  add_foreign_key "series", "sources"
  add_foreign_key "snapshots", "locations"
  add_foreign_key "snapshots", "sources"
end
