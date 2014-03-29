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

ActiveRecord::Schema.define(version: 20140227115607) do

  create_table "alliances", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  create_table "allies", force: true do |t|
    t.integer  "corp_id"
    t.integer  "alliance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chars", force: true do |t|
    t.string   "name"
    t.integer  "corp_id"
    t.boolean  "anon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "key_id"
    t.string   "corp_name"
    t.string   "alliance_name"
    t.integer  "alliance_id"
  end

  add_index "chars", ["alliance_name"], name: "index_chars_on_alliance_name", using: :btree

  create_table "corps", force: true do |t|
    t.string   "name"
    t.integer  "alliance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alliance_name"
  end

  add_index "corps", ["alliance_name"], name: "index_corps_on_alliance_name", using: :btree

  create_table "drops", force: true do |t|
    t.string   "name"
    t.boolean  "market"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rat_id"
    t.integer  "site_id"
    t.boolean  "guaranteed"
  end

  create_table "keys", force: true do |t|
    t.string   "vcode"
    t.integer  "mask"
    t.boolean  "working"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "key_type"
    t.datetime "expires"
  end

  create_table "kills", force: true do |t|
    t.datetime "ts"
    t.string   "rat_name"
    t.string   "rat_type"
    t.integer  "rat_amount"
    t.string   "char_name"
    t.string   "corp_name"
    t.string   "alliance_name"
    t.integer  "char_id"
    t.integer  "corp_id"
    t.integer  "alliance_id"
    t.integer  "wallet_record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rat_id"
    t.integer  "user_id"
    t.boolean  "anon"
  end

  add_index "kills", ["alliance_id"], name: "index_kills_on_alliance_id", using: :btree
  add_index "kills", ["alliance_name"], name: "index_kills_on_alliance_name", using: :btree
  add_index "kills", ["char_id"], name: "index_kills_on_char_id", using: :btree
  add_index "kills", ["char_name"], name: "index_kills_on_char_name", using: :btree
  add_index "kills", ["corp_id"], name: "index_kills_on_corp_id", using: :btree
  add_index "kills", ["corp_name"], name: "index_kills_on_corp_name", using: :btree
  add_index "kills", ["rat_name"], name: "index_kills_on_rat_name", using: :btree
  add_index "kills", ["ts"], name: "index_kills_on_ts", using: :btree
  add_index "kills", ["wallet_record_id"], name: "index_kills_on_wallet_record_id", using: :btree

  create_table "rat_images", force: true do |t|
    t.integer  "rat_id"
    t.string   "md5"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rats", force: true do |t|
    t.string   "name"
    t.string   "rat_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "site_id"
  end

  create_table "sites", force: true do |t|
    t.string   "name"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "faction"
  end

  create_table "type_attribs", force: true do |t|
    t.integer  "type_id"
    t.string   "name"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "type_attribs", ["name"], name: "index_type_attribs_on_name", using: :btree
  add_index "type_attribs", ["type_id"], name: "index_type_attribs_on_type_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wallet_records", force: true do |t|
    t.datetime "ts"
    t.string   "char_name"
    t.string   "corp_name"
    t.string   "alliance_name"
    t.integer  "ref_type_id"
    t.integer  "amount",        limit: 8
    t.integer  "tax",           limit: 8
    t.integer  "char_id"
    t.integer  "corp_id"
    t.integer  "alliance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "anon"
  end

  add_index "wallet_records", ["alliance_id"], name: "index_wallet_records_on_alliance_id", using: :btree
  add_index "wallet_records", ["alliance_name"], name: "index_wallet_records_on_alliance_name", using: :btree
  add_index "wallet_records", ["char_id"], name: "index_wallet_records_on_char_id", using: :btree
  add_index "wallet_records", ["char_name"], name: "index_wallet_records_on_char_name", using: :btree
  add_index "wallet_records", ["corp_id"], name: "index_wallet_records_on_corp_id", using: :btree
  add_index "wallet_records", ["corp_name"], name: "index_wallet_records_on_corp_name", using: :btree
  add_index "wallet_records", ["ts"], name: "index_wallet_records_on_ts", using: :btree

end
