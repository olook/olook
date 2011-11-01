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

ActiveRecord::Schema.define(:version => 20111101213603) do

  create_table "admins", :force => true do |t|
    t.string   "email",                              :default => "", :null => false
    t.string   "encrypted_password",  :limit => 128, :default => "", :null => false
    t.integer  "failed_attempts",                    :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "sign_in_count",                      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "answers", :force => true do |t|
    t.string   "title"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "details", :force => true do |t|
    t.integer  "product_id"
    t.string   "translation_token"
    t.text     "description"
    t.integer  "display_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "type",        :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["created_at"], :name => "index_events_on_created_at"
  add_index "events", ["type"], :name => "index_events_on_type"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "invites", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "accepted_at"
    t.integer  "invited_member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
  end

  add_index "invites", ["email"], :name => "index_invites_on_email"
  add_index "invites", ["invited_member_id"], :name => "index_invites_on_invited_member_id"
  add_index "invites", ["user_id"], :name => "index_invites_on_user_id"

  create_table "pictures", :force => true do |t|
    t.string   "image"
    t.integer  "display_on"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pictures", ["product_id"], :name => "index_pictures_on_product_id"

  create_table "points", :force => true do |t|
    t.integer  "value"
    t.integer  "user_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model_number"
  end

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_visit_banner"
  end

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "related_products", :force => true do |t|
    t.integer  "product_a_id", :null => false
    t.integer  "product_b_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "related_products", ["product_a_id"], :name => "index_related_products_on_product_a_id"
  add_index "related_products", ["product_b_id"], :name => "index_related_products_on_product_b_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "survey_answers", :force => true do |t|
    t.integer  "user_id"
    t.text     "answers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "invite_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "uid"
    t.text     "facebook_token"
    t.string   "cpf"
    t.boolean  "is_invited"
    t.date     "birthday"
  end

  add_index "users", ["invite_token"], :name => "index_users_on_invite_token"
  add_index "users", ["uid"], :name => "index_users_on_uid"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "variants", :force => true do |t|
    t.integer  "product_id"
    t.string   "number"
    t.string   "description"
    t.string   "display_reference"
    t.decimal  "price",             :precision => 10, :scale => 2
    t.integer  "inventory"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "variants", ["product_id"], :name => "index_variants_on_product_id"

  create_table "weights", :force => true do |t|
    t.integer "profile_id"
    t.integer "answer_id"
    t.integer "weight"
  end

end
