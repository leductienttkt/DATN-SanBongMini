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

ActiveRecord::Schema.define(version: 20170401033126) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",          limit: 65535
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "message"
    t.string   "eventable_type"
    t.integer  "eventable_id"
    t.string   "eventitem_id"
    t.boolean  "read",           default: false
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "match_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "match_id"
    t.integer "user_id"
    t.integer "quantity", default: 1
    t.index ["match_id"], name: "index_match_users_on_match_id", using: :btree
    t.index ["user_id"], name: "index_match_users_on_user_id", using: :btree
  end

  create_table "matches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "available_quantity"
    t.integer "max_quantity"
    t.integer "rent_id"
    t.index ["rent_id"], name: "index_matches_on_rent_id", using: :btree
  end

  create_table "mini_pitches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.float    "price",       limit: 24
    t.string   "image"
    t.integer  "status",                    default: 0
    t.integer  "pitch_type"
    t.time     "start_hour"
    t.time     "end_hour"
    t.integer  "pitch_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["name"], name: "index_mini_pitches_on_name", using: :btree
    t.index ["pitch_id"], name: "index_mini_pitches_on_pitch_id", using: :btree
    t.index ["pitch_type"], name: "index_mini_pitches_on_pitch_type", using: :btree
  end

  create_table "pitches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description",      limit: 65535
    t.integer  "status",                         default: 0
    t.string   "cover_image"
    t.string   "avatar"
    t.float    "averate_rating",   limit: 24
    t.time     "time_auto_reject",               default: '2000-01-01 00:30:00'
    t.integer  "owner_id"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.index ["owner_id"], name: "index_pitches_on_owner_id", using: :btree
  end

  create_table "promotions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date    "start_date"
    t.date    "end_date"
    t.text    "content",    limit: 65535
    t.integer "pitch_id"
    t.index ["pitch_id"], name: "index_promotions_on_pitch_id", using: :btree
  end

  create_table "rents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.time    "start_hour"
    t.time    "end_hour"
    t.date    "date"
    t.integer "status",     default: 0
    t.integer "pitch_id"
    t.integer "user_id"
    t.index ["pitch_id"], name: "index_rents_on_pitch_id", using: :btree
    t.index ["user_id"], name: "index_rents_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "avatar"
    t.string   "phone"
    t.string   "description"
    t.integer  "status",                 default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "vip_customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "quantity", default: 1
    t.integer "user_id"
    t.integer "pitch_id"
    t.index ["pitch_id"], name: "index_vip_customers_on_pitch_id", using: :btree
    t.index ["user_id"], name: "index_vip_customers_on_user_id", using: :btree
  end

  add_foreign_key "comments", "users"
  add_foreign_key "events", "users"
  add_foreign_key "match_users", "matches"
  add_foreign_key "match_users", "users"
  add_foreign_key "matches", "rents"
  add_foreign_key "mini_pitches", "pitches"
  add_foreign_key "promotions", "pitches"
  add_foreign_key "rents", "pitches"
  add_foreign_key "rents", "users"
  add_foreign_key "vip_customers", "pitches"
  add_foreign_key "vip_customers", "users"
end
