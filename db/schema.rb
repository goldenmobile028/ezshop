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

ActiveRecord::Schema.define(version: 20180321081526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beacons", force: :cascade do |t|
    t.string   "uuid"
    t.string   "identifier"
    t.integer  "major"
    t.integer  "minor"
    t.integer  "store_id"
    t.boolean  "is_enabled"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "xpos"
    t.float    "ypos"
    t.boolean  "is_boundary"
  end

  create_table "item_favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.boolean  "favorite",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["item_id"], name: "index_item_favorites_on_item_id", using: :btree
    t.index ["user_id"], name: "index_item_favorites_on_user_id", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "latitudeDelta"
    t.float    "longitudeDelta"
    t.string   "thumbnail"
    t.string   "store_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "location"
    t.string   "beacon_id"
  end

  create_table "store_favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.boolean  "favorite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_store_favorites_on_store_id", using: :btree
    t.index ["user_id"], name: "index_store_favorites_on_user_id", using: :btree
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "thumb_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.string   "encrypted_password"
    t.integer  "user_type"
    t.string   "social"
    t.string   "auth_token"
    t.string   "password_token"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_foreign_key "item_favorites", "items"
  add_foreign_key "item_favorites", "users"
  add_foreign_key "store_favorites", "stores"
  add_foreign_key "store_favorites", "users"
end
