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

ActiveRecord::Schema.define(version: 20131122034440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analysis_requests", force: true do |t|
    t.string   "enrolle_code",            limit: 7,               null: false
    t.integer  "product_code",                                    null: false
    t.integer  "variety_code"
    t.date     "generated_at",                                    null: false
    t.integer  "destiny_codes",                                                array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",                                        null: false
    t.integer  "harvest",                                         null: false
    t.text     "observations"
    t.datetime "deleted_at"
    t.string   "request_type",            limit: 1, default: "p"
    t.string   "depositary_enrolle_code", limit: 7
    t.text     "source_analysis"
  end

  add_index "analysis_requests", ["enrolle_code"], name: "index_analysis_requests_on_enrolle_code", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                                null: false
    t.string   "lastname"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "roles_mask",             default: 0,  null: false
    t.integer  "lock_version",           default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["lastname"], name: "index_users_on_lastname", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["whodunnit"], name: "index_versions_on_whodunnit", using: :btree

end
