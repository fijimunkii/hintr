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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131111212059) do

  create_table "likes", :force => true do |t|
    t.integer  "match_id"
    t.string   "fb_id"
    t.string   "like_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "matches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "related_user_id"
    t.integer  "weight"
    t.string   "relationship_status"
    t.string   "name"
    t.string   "profile_picture"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "pictures", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.integer  "num_likes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "fb_id"
    t.string   "email"
    t.string   "name"
    t.string   "gender"
    t.string   "interested_in"
    t.string   "relationship_status"
    t.string   "location"
    t.string   "profile_picture"
    t.date     "date_of_birth"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "watched_intro",       :default => false
    t.integer  "max_weight",          :default => 0
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

end
