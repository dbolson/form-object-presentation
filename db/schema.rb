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

ActiveRecord::Schema.define(version: 20140302171138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flavors", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ice_creams", force: true do |t|
    t.integer  "flavor_id",       null: false
    t.integer  "serving_size_id", null: false
    t.integer  "scoops",          null: false
    t.integer  "price",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ice_creams", ["flavor_id"], name: "index_ice_creams_on_flavor_id", using: :btree
  add_index "ice_creams", ["serving_size_id"], name: "index_ice_creams_on_serving_size_id", using: :btree

  create_table "ice_creams_toppings", id: false, force: true do |t|
    t.integer "ice_cream_id", null: false
    t.integer "topping_id",   null: false
  end

  add_index "ice_creams_toppings", ["ice_cream_id"], name: "index_ice_creams_toppings_on_ice_cream_id", using: :btree
  add_index "ice_creams_toppings", ["topping_id"], name: "index_ice_creams_toppings_on_topping_id", using: :btree

  create_table "memes", force: true do |t|
    t.integer  "ice_cream_id", null: false
    t.string   "name",         null: false
    t.integer  "rating",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memes", ["ice_cream_id"], name: "index_memes_on_ice_cream_id", using: :btree

  create_table "serving_sizes", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "toppings", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
