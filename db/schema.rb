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

ActiveRecord::Schema.define(version: 20140101004723) do

  create_table "cards", force: true do |t|
    t.integer  "hand_id"
    t.integer  "round_id"
    t.integer  "value"
    t.integer  "suit"
    t.boolean  "dealt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["hand_id"], name: "index_cards_on_hand_id"
  add_index "cards", ["round_id"], name: "index_cards_on_round_id"

  create_table "hands", force: true do |t|
    t.integer  "round_id"
    t.integer  "user_id"
    t.boolean  "dealer"
    t.boolean  "current",    default: true
    t.integer  "score"
    t.boolean  "played"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hands", ["round_id"], name: "index_hands_on_round_id"
  add_index "hands", ["user_id"], name: "index_hands_on_user_id"

  create_table "rounds", force: true do |t|
    t.boolean  "current",    default: true
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end