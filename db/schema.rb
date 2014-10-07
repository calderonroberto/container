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

ActiveRecord::Schema.define(:version => 20141007191256) do

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.string   "thumbnail_url",                       :default => "app_thumbnail.png"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.string   "mobile_url"
    t.string   "url_uploaded_file_name"
    t.string   "url_uploaded_content_type"
    t.integer  "url_uploaded_file_size"
    t.datetime "url_uploaded_updated_at"
    t.string   "mobile_url_uploaded_file_name"
    t.string   "mobile_url_uploaded_content_type"
    t.integer  "mobile_url_uploaded_file_size"
    t.datetime "mobile_url_uploaded_updated_at"
    t.string   "thumbnail_url_uploaded_file_name"
    t.string   "thumbnail_url_uploaded_content_type"
    t.integer  "thumbnail_url_uploaded_file_size"
    t.datetime "thumbnail_url_uploaded_updated_at"
  end

  add_index "apps", ["name"], :name => "index_apps_on_name", :unique => true

  create_table "checkins", :force => true do |t|
    t.integer  "user_id"
    t.integer  "display_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "displays", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "unique_id",       :limit => 8
  end

  add_index "displays", ["remember_token", "name"], :name => "index_displays_on_remember_token_and_name"
  add_index "displays", ["unique_id"], :name => "index_displays_on_unique_id"

  create_table "logs", :force => true do |t|
    t.string   "controller"
    t.string   "method"
    t.integer  "user_id"
    t.integer  "display_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "params"
    t.integer  "app_id"
    t.string   "remote_ip"
  end

  create_table "messages", :force => true do |t|
    t.string   "from"
    t.string   "message"
    t.string   "to"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "read",       :default => false
  end

  add_index "messages", ["from"], :name => "index_messages_on_from"
  add_index "messages", ["to"], :name => "index_messages_on_to"

  create_table "notes", :force => true do |t|
    t.string   "from"
    t.string   "message"
    t.integer  "display_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "notes", ["display_id"], :name => "index_notes_on_display_id"
  add_index "notes", ["from"], :name => "index_notes_on_from"

  create_table "registrations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "display_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "registrations", ["display_id"], :name => "index_registrations_on_display_id"
  add_index "registrations", ["user_id"], :name => "index_registrations_on_user_id"

  create_table "setups", :force => true do |t|
    t.string   "thingbroker_url",       :default => "http://kimberly.magic.ubc.ca:8080/thingbroker"
    t.integer  "display_id"
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.boolean  "interact_instructions"
  end

  add_index "setups", ["display_id"], :name => "index_setups_on_display_id"

  create_table "stagings", :force => true do |t|
    t.integer  "display_id"
    t.integer  "app_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stagings", ["app_id"], :name => "index_stagings_on_app_id"
  add_index "stagings", ["display_id"], :name => "index_stagings_on_display_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "app_id"
    t.integer  "display_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "subscriptions", ["app_id"], :name => "index_subscriptions_on_app_id"
  add_index "subscriptions", ["display_id"], :name => "index_subscriptions_on_display_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.text     "token"
    t.string   "thumbnail_url"
    t.string   "picture_url"
    t.text     "friends"
    t.integer  "test_group",             :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
