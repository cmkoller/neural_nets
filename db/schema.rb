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

ActiveRecord::Schema.define(version: 20141211171028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", force: true do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.float   "weight"
  end

  create_table "desired_outputs", force: true do |t|
    t.integer "net_id",          null: false
    t.integer "preset_input_id"
    t.string  "values",          null: false
    t.string  "name",            null: false
  end

  create_table "nets", force: true do |t|
  end

  create_table "nodes", force: true do |t|
    t.integer "net_id"
    t.integer "layer"
    t.float   "output",      default: 0.0
    t.float   "total_input", default: 0.0
  end

  create_table "preset_inputs", force: true do |t|
    t.integer "net_id", null: false
    t.string  "values", null: false
    t.string  "name",   null: false
  end

end
