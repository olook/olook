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

ActiveRecord::Schema.define(:version => 20131106202200) do

  create_table "action_parameters", :force => true do |t|
    t.integer  "matchable_id"
    t.integer  "promotion_action_id"
    t.string   "action_params"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "matchable_type"
  end

  add_index "action_parameters", ["matchable_id", "matchable_type"], :name => "index_action_parameters_on_matchable_id_and_matchable_type"

  create_table "addresses", :force => true do |t|
    t.integer "user_id"
    t.string  "country"
    t.string  "city"
    t.string  "state"
    t.string  "complement"
    t.string  "street"
    t.integer "number"
    t.string  "neighborhood"
    t.string  "zip_code"
    t.string  "telephone"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "mobile"
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

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
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role_id"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "answers", :force => true do |t|
    t.string   "title"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order"
    t.string   "picture_name"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "header_image"
    t.string   "header_image_alt"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "seo_text"
  end

  create_table "braspag_authorize_responses", :force => true do |t|
    t.string   "correlation_id"
    t.boolean  "success"
    t.string   "error_message"
    t.string   "identification_code"
    t.string   "braspag_order_id"
    t.string   "braspag_transaction_id"
    t.string   "amount"
    t.integer  "payment_method"
    t.string   "acquirer_transaction_id"
    t.string   "authorization_code"
    t.string   "return_code"
    t.string   "return_message"
    t.integer  "status"
    t.string   "credit_card_token"
    t.boolean  "processed",               :default => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "retries",                 :default => 0
  end

  add_index "braspag_authorize_responses", ["identification_code"], :name => "index_braspag_authorize_responses_on_order_id"

  create_table "braspag_capture_responses", :force => true do |t|
    t.string   "correlation_id"
    t.boolean  "success"
    t.boolean  "processed",               :default => false
    t.string   "error_message"
    t.string   "braspag_transaction_id"
    t.string   "acquirer_transaction_id"
    t.string   "amount"
    t.string   "authorization_code"
    t.string   "return_code"
    t.string   "return_message"
    t.integer  "status"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "identification_code"
    t.integer  "retries",                 :default => 0
  end

  add_index "braspag_capture_responses", ["identification_code"], :name => "index_braspag_capture_responses_on_order_id"

  create_table "campaign_emails", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "converted_user", :default => false
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.string   "phone"
    t.string   "profile"
  end

  add_index "campaign_emails", ["email"], :name => "index_campaign_emails_on_email"

  create_table "campaign_pages", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "page_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.date     "start_at"
    t.date     "end_at"
    t.string   "banner"
    t.string   "background"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
    t.string   "title"
    t.string   "link"
    t.string   "lightbox"
  end

  add_index "campaigns", ["start_at", "end_at"], :name => "index_campaigns_on_start_at_and_end_at"

  create_table "campaing_participants", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "gender"
    t.string   "campaing"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cart_item_adjustments", :force => true do |t|
    t.decimal  "value",        :precision => 10, :scale => 2
    t.integer  "cart_item_id"
    t.string   "source"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "cart_items", :force => true do |t|
    t.integer "variant_id",                       :null => false
    t.integer "cart_id",                          :null => false
    t.integer "quantity",      :default => 1,     :null => false
    t.integer "gift_position", :default => 0,     :null => false
    t.boolean "gift",          :default => false, :null => false
  end

  add_index "cart_items", ["cart_id"], :name => "index_cart_items_on_cart_id"
  add_index "cart_items", ["variant_id"], :name => "index_cart_items_on_variant_id"

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "notified",                :default => false, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "legacy_id"
    t.boolean  "gift_wrap",               :default => false
    t.boolean  "use_credits",             :default => false
    t.integer  "coupon_id"
    t.integer  "address_id"
    t.boolean  "facebook_share_discount"
  end

  add_index "carts", ["address_id"], :name => "index_carts_on_address_id"
  add_index "carts", ["coupon_id"], :name => "index_carts_on_coupon_id"
  add_index "carts", ["notified"], :name => "index_carts_on_notified"
  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "carts_backup", :id => false, :force => true do |t|
    t.integer  "id",          :default => 0,     :null => false
    t.integer  "user_id"
    t.boolean  "notified",    :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "legacy_id"
    t.boolean  "gift_wrap",   :default => false
    t.boolean  "use_credits", :default => false
    t.integer  "coupon_id"
    t.integer  "address_id"
  end

  create_table "catalog_bases", :force => true do |t|
    t.string   "url"
    t.string   "type"
    t.string   "seo_text"
    t.string   "small_banner1"
    t.string   "alt_small_banner1"
    t.string   "link_small_banner1"
    t.string   "small_banner2"
    t.string   "alt_small_banner2"
    t.string   "link_small_banner2"
    t.string   "medium_banner"
    t.string   "alt_medium_banner"
    t.string   "link_medium_banner"
    t.string   "big_banner"
    t.string   "alt_big_banner"
    t.string   "link_big_banner"
    t.string   "title"
    t.string   "resume_title"
    t.text     "text_complement"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.boolean  "enabled"
    t.text     "product_list"
    t.string   "organic_url"
    t.integer  "url_type"
  end

  create_table "catalog_products", :force => true do |t|
    t.integer  "catalog_id"
    t.integer  "product_id"
    t.integer  "category_id"
    t.string   "subcategory_name"
    t.string   "subcategory_name_label"
    t.integer  "shoe_size"
    t.string   "shoe_size_label"
    t.string   "heel"
    t.string   "heel_label"
    t.decimal  "original_price",         :precision => 10, :scale => 2
    t.decimal  "retail_price",           :precision => 10, :scale => 2
    t.float    "discount_percent"
    t.integer  "variant_id"
    t.integer  "inventory"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "cloth_size"
    t.string   "brand"
  end

  add_index "catalog_products", ["catalog_id", "category_id"], :name => "index_catalog_products_on_catalog_id_and_category_id"
  add_index "catalog_products", ["catalog_id"], :name => "index_catalog_products_on_catalog_id"
  add_index "catalog_products", ["category_id", "inventory"], :name => "index_catalog_products_on_category_id_and_inventory"
  add_index "catalog_products", ["category_id"], :name => "index_catalog_products_on_category_id"
  add_index "catalog_products", ["heel"], :name => "index_catalog_products_on_heel"
  add_index "catalog_products", ["original_price"], :name => "index_catalog_products_on_original_price"
  add_index "catalog_products", ["product_id"], :name => "index_catalog_products_on_product_id"
  add_index "catalog_products", ["retail_price"], :name => "index_catalog_products_on_retail_price"
  add_index "catalog_products", ["shoe_size"], :name => "index_catalog_products_on_shoe_size"
  add_index "catalog_products", ["subcategory_name"], :name => "index_catalog_products_on_subcategory_name"

  create_table "catalogs", :force => true do |t|
    t.string   "type"
    t.integer  "association_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "ceps", :force => true do |t|
    t.string   "cep"
    t.string   "endereco"
    t.string   "bairro"
    t.string   "cidade"
    t.string   "estado"
    t.string   "nome_estado"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "ceps", ["cep"], :name => "index_ceps_on_cep", :unique => true

  create_table "clearsale_order_responses", :force => true do |t|
    t.integer  "order_id"
    t.string   "status"
    t.decimal  "score",        :precision => 10, :scale => 0
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.boolean  "processed",                                   :default => false
    t.datetime "last_attempt"
  end

  add_index "clearsale_order_responses", ["order_id"], :name => "index_clearsale_order_responses_on_order_id"

  create_table "clippings", :force => true do |t|
    t.string   "logo"
    t.string   "title"
    t.text     "clipping_text"
    t.date     "published_at"
    t.string   "source"
    t.string   "link"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "alt"
    t.string   "pdf_file"
  end

  create_table "collection_theme_groups", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "collection_themes", :force => true do |t|
    t.string   "name"
    t.boolean  "active",                    :default => false
    t.string   "slug"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "header_image"
    t.integer  "position",                  :default => 1
    t.integer  "collection_theme_group_id"
    t.string   "video_link"
    t.string   "header_image_alt"
    t.string   "text_color"
    t.string   "seo_text"
  end

  add_index "collection_themes", ["collection_theme_group_id"], :name => "index_collection_themes_on_collection_theme_group_id"
  add_index "collection_themes", ["slug"], :name => "index_moments_on_slug", :unique => true

  create_table "collection_themes_products", :id => false, :force => true do |t|
    t.integer "collection_theme_id"
    t.integer "product_id"
  end

  create_table "collections", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",  :default => false
  end

  add_index "collections", ["end_date"], :name => "index_collections_on_end_date"
  add_index "collections", ["start_date"], :name => "index_collections_on_start_date"

  create_table "consolidated_sells", :force => true do |t|
    t.string   "category"
    t.date     "day"
    t.integer  "amount"
    t.decimal  "total",        :precision => 8, :scale => 2
    t.string   "subcategory"
    t.decimal  "total_retail", :precision => 8, :scale => 2
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "product_id"
  end

  create_table "contact_informations", :force => true do |t|
    t.string   "title"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.string   "code"
    t.decimal  "value",                :precision => 8, :scale => 2
    t.integer  "remaining_amount"
    t.boolean  "unlimited"
    t.boolean  "active"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_percentage"
    t.integer  "used_amount",                                        :default => 0
    t.string   "campaign"
    t.string   "campaign_description"
    t.string   "created_by"
    t.string   "updated_by"
    t.string   "brand"
    t.integer  "modal",                                              :default => 1
  end

  add_index "coupons", ["code"], :name => "index_coupons_on_code"

  create_table "credit_types", :force => true do |t|
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "code"
  end

  add_index "credit_types", ["code"], :name => "index_credit_types_on_code", :unique => true

  create_table "credits", :force => true do |t|
    t.string   "source"
    t.decimal  "value",              :precision => 10, :scale => 2
    t.integer  "multiplier"
    t.decimal  "total",              :precision => 10, :scale => 2
    t.integer  "user_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reason"
    t.boolean  "is_debit",                                          :default => false
    t.datetime "activates_at"
    t.datetime "expires_at"
    t.integer  "original_credit_id"
    t.integer  "user_credit_id"
    t.integer  "admin_id"
    t.integer  "line_item_id"
  end

  add_index "credits", ["activates_at"], :name => "index_credits_on_activates_at"
  add_index "credits", ["expires_at"], :name => "index_credits_on_expires_at"
  add_index "credits", ["line_item_id"], :name => "index_credits_on_line_item_id"
  add_index "credits", ["order_id"], :name => "index_credits_on_order_id"
  add_index "credits", ["original_credit_id"], :name => "index_credits_on_original_credit_id"
  add_index "credits", ["source"], :name => "index_credits_on_source"
  add_index "credits", ["user_credit_id"], :name => "index_credits_on_user_credit_id"
  add_index "credits", ["user_id"], :name => "index_credits_on_user_id"

  create_table "details", :force => true do |t|
    t.integer  "product_id"
    t.string   "translation_token"
    t.text     "description"
    t.integer  "display_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "details", ["product_id"], :name => "index_details_on_product_id"

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_type",  :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["created_at"], :name => "index_events_on_created_at"
  add_index "events", ["event_type"], :name => "index_events_on_event_type"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "freebie_variants", :force => true do |t|
    t.integer  "variant_id"
    t.integer  "freebie_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "freight_ab_test_report", :id => false, :force => true do |t|
    t.integer "user_id"
  end

  create_table "freight_prices", :force => true do |t|
    t.integer  "shipping_service_id"
    t.integer  "zip_start"
    t.integer  "zip_end"
    t.decimal  "order_value_start",   :precision => 8, :scale => 3
    t.decimal  "order_value_end",     :precision => 8, :scale => 3
    t.integer  "delivery_time"
    t.decimal  "price",               :precision => 8, :scale => 2
    t.decimal  "cost",                :precision => 8, :scale => 2
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "freight_prices", ["order_value_end"], :name => "index_freight_prices_on_order_value_end"
  add_index "freight_prices", ["order_value_start"], :name => "index_freight_prices_on_order_value_start"
  add_index "freight_prices", ["shipping_service_id"], :name => "index_freight_prices_on_shipping_service_id"
  add_index "freight_prices", ["zip_end"], :name => "index_freight_prices_on_zip_end"
  add_index "freight_prices", ["zip_start"], :name => "index_freight_prices_on_zip_start"

  create_table "freights", :force => true do |t|
    t.decimal "price",               :precision => 8, :scale => 2
    t.decimal "cost",                :precision => 8, :scale => 2
    t.integer "delivery_time"
    t.integer "order_id"
    t.integer "address_id"
    t.integer "shipping_service_id",                               :default => 1
    t.string  "tracking_code"
    t.string  "country"
    t.string  "city"
    t.string  "state"
    t.string  "complement"
    t.string  "street"
    t.string  "number"
    t.string  "neighborhood"
    t.string  "zip_code"
    t.string  "telephone"
    t.string  "mobile"
  end

  add_index "freights", ["order_id"], :name => "index_freights_on_order_id"
  add_index "freights", ["shipping_service_id"], :name => "index_freights_on_shipping_service_id"

  create_table "frete_view", :id => false, :force => true do |t|
    t.integer "user_id"
    t.string  "cep",     :limit => 9
    t.string  "tabela",  :limit => 1
    t.string  "acao",    :limit => 7, :default => "", :null => false
  end

  create_table "gift_boxes", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.string   "thumb_image"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  create_table "gift_boxes_products", :force => true do |t|
    t.integer  "gift_box_id"
    t.integer  "product_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "gift_occasion_types", :force => true do |t|
    t.string   "name",                       :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "day"
    t.integer  "month"
    t.integer  "gift_recipient_relation_id"
  end

  add_index "gift_occasion_types", ["gift_recipient_relation_id"], :name => "index_gift_occasion_types_on_gift_recipient_relation_id"

  create_table "gift_occasions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "gift_recipient_id"
    t.integer  "gift_occasion_type_id"
    t.integer  "day"
    t.integer  "month"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "gift_recipient_relations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gift_recipients", :force => true do |t|
    t.integer  "user_id"
    t.string   "facebook_uid"
    t.string   "name"
    t.integer  "shoe_size"
    t.integer  "gift_recipient_relation_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "profile_id"
    t.text     "ranked_profile_ids"
  end

  create_table "highlight_campaigns", :force => true do |t|
    t.string   "label"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "product_ids"
  end

  create_table "highlights", :force => true do |t|
    t.string   "link"
    t.string   "image"
    t.integer  "position"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "title"
    t.string   "subtitle"
    t.integer  "highlight_type"
  end

  create_table "holidays", :force => true do |t|
    t.date     "event_date"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invites", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.datetime "accepted_at"
    t.integer  "invited_member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.boolean  "resubmitted"
  end

  add_index "invites", ["accepted_at"], :name => "index_invites_on_accepted_at"
  add_index "invites", ["email"], :name => "index_invites_on_email"
  add_index "invites", ["invited_member_id"], :name => "index_invites_on_invited_member_id"
  add_index "invites", ["user_id"], :name => "index_invites_on_user_id"

  create_table "line_items", :force => true do |t|
    t.integer "variant_id"
    t.integer "order_id"
    t.integer "quantity"
    t.decimal "price",        :precision => 8, :scale => 3
    t.boolean "gift"
    t.decimal "retail_price", :precision => 8, :scale => 3
    t.boolean "is_freebie",                                 :default => false
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["variant_id"], :name => "index_line_items_on_variant_id"

  create_table "liquidation_carousels", :force => true do |t|
    t.integer  "liquidation_id"
    t.string   "image"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "liquidation_products", :force => true do |t|
    t.integer  "liquidation_id"
    t.integer  "product_id"
    t.integer  "category_id"
    t.string   "subcategory_name"
    t.decimal  "original_price",         :precision => 10, :scale => 2
    t.decimal  "retail_price",           :precision => 10, :scale => 2
    t.float    "discount_percent"
    t.integer  "shoe_size"
    t.string   "heel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inventory"
    t.string   "shoe_size_label"
    t.string   "heel_label"
    t.string   "subcategory_name_label"
    t.integer  "variant_id"
  end

  add_index "liquidation_products", ["liquidation_id"], :name => "index_liquidation_products_on_liquidation_id"
  add_index "liquidation_products", ["product_id"], :name => "index_liquidation_products_on_product_id"

  create_table "liquidations", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "teaser"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "welcome_banner"
    t.string   "lightbox_banner"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "resume"
    t.string   "teaser_banner"
    t.boolean  "visible",         :default => true
    t.boolean  "show_advertise",  :default => true
    t.string   "big_banner"
  end

  create_table "live_feeds", :force => true do |t|
    t.string   "firstname"
    t.string   "gender"
    t.date     "birthdate"
    t.string   "email"
    t.string   "ip"
    t.integer  "question"
    t.string   "zip"
    t.string   "lastname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lookbooks", :force => true do |t|
    t.string   "name"
    t.string   "thumb_image"
    t.boolean  "active",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "icon"
    t.string   "icon_over"
    t.string   "fg_color"
    t.string   "bg_color"
    t.string   "movie_image"
  end

  create_table "moip_callbacks", :force => true do |t|
    t.integer  "order_id"
    t.string   "id_transacao"
    t.string   "cod_moip"
    t.string   "tipo_pagamento"
    t.string   "status_pagamento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "classificacao"
    t.integer  "payment_id"
    t.boolean  "processed",        :default => false
    t.integer  "retry",            :default => 0
    t.text     "error"
  end

  add_index "moip_callbacks", ["id_transacao"], :name => "index_moip_callbacks_on_id_transacao"
  add_index "moip_callbacks", ["payment_id"], :name => "index_moip_callbacks_on_payment_id"
  add_index "moip_callbacks", ["processed"], :name => "index_moip_callbacks_on_processed"

  create_table "order_state_transitions", :force => true do |t|
    t.integer  "order_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
    t.string   "payment_response"
    t.string   "payment_transaction_status"
    t.string   "gateway_status_reason"
  end

  add_index "order_state_transitions", ["order_id"], :name => "index_order_state_transitions_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "credits",                            :precision => 8, :scale => 2, :default => 0.0
    t.string   "state"
    t.integer  "number",                :limit => 8
    t.string   "invoice_number"
    t.string   "invoice_serie"
    t.integer  "in_cart_notified",                                                 :default => 0
    t.boolean  "disable",                                                          :default => false
    t.boolean  "gift_wrap",                                                        :default => false
    t.string   "gift_message"
    t.boolean  "restricted",                                                       :default => false, :null => false
    t.datetime "purchased_at"
    t.string   "state_reason"
    t.integer  "cart_id"
    t.decimal  "amount_discount",                    :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "amount_increase",                    :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "amount_paid",                        :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "subtotal",                           :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.datetime "erp_integrate_at"
    t.datetime "erp_cancel_at"
    t.datetime "erp_payment_at"
    t.text     "erp_integrate_error"
    t.text     "erp_cancel_error"
    t.text     "erp_payment_error"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.string   "user_email"
    t.string   "user_cpf"
    t.decimal  "gross_amount",                       :precision => 8, :scale => 2
    t.integer  "gateway"
    t.integer  "tracking_id"
    t.datetime "expected_delivery_on"
    t.string   "shipping_service_name", :limit => 5
    t.string   "freight_state",         :limit => 3
  end

  add_index "orders", ["cart_id"], :name => "index_orders_on_cart_id"
  add_index "orders", ["expected_delivery_on"], :name => "index_orders_on_expected_delivery_on"
  add_index "orders", ["freight_state"], :name => "index_orders_on_freight_state"
  add_index "orders", ["number"], :name => "index_orders_on_number", :unique => true
  add_index "orders", ["shipping_service_name"], :name => "index_orders_on_shipping_service_name"
  add_index "orders", ["user_email"], :name => "index_orders_on_user_email"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "pages", :force => true do |t|
    t.string   "controller_name"
    t.string   "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "state"
    t.string   "user_name"
    t.string   "credit_card_number"
    t.string   "bank"
    t.string   "expiration_date"
    t.string   "telephone"
    t.string   "user_birthday"
    t.integer  "payments"
    t.integer  "gateway_status"
    t.string   "gateway_code"
    t.string   "gateway_type"
    t.datetime "payment_expiration_date"
    t.boolean  "reminder_sent",                                            :default => false
    t.string   "gateway_status_reason"
    t.string   "identification_code"
    t.integer  "cart_id"
    t.integer  "credit_type_id"
    t.text     "credit_ids"
    t.integer  "coupon_id"
    t.decimal  "total_paid",                 :precision => 8, :scale => 2
    t.integer  "promotion_id"
    t.integer  "discount_percent"
    t.decimal  "percent",                    :precision => 8, :scale => 2
    t.string   "gateway_response_id"
    t.string   "gateway_response_status"
    t.text     "gateway_token"
    t.decimal  "gateway_fee",                :precision => 8, :scale => 2
    t.string   "gateway_origin_code"
    t.string   "gateway_transaction_status"
    t.string   "gateway_message"
    t.string   "gateway_transaction_code"
    t.integer  "gateway_return_code"
    t.integer  "user_id"
    t.integer  "gateway"
    t.string   "security_code"
    t.string   "source"
    t.string   "mercado_pago_id"
  end

  add_index "payments", ["cart_id"], :name => "index_payments_on_cart_id"
  add_index "payments", ["coupon_id"], :name => "index_payments_on_coupon_id"
  add_index "payments", ["credit_type_id"], :name => "index_payments_on_credit_type_id"
  add_index "payments", ["identification_code"], :name => "index_payments_on_identification_code"
  add_index "payments", ["order_id"], :name => "index_payments_on_order_id"
  add_index "payments", ["payment_expiration_date"], :name => "index_payments_on_payment_expiration_date"
  add_index "payments", ["percent"], :name => "index_payments_on_percent"
  add_index "payments", ["promotion_id"], :name => "index_payments_on_promotion_id"
  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "permissions", :force => true do |t|
    t.string   "model_name"
    t.string   "action_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  create_table "pictures", :force => true do |t|
    t.string   "image"
    t.integer  "display_on"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   :default => 100
  end

  add_index "pictures", ["position"], :name => "index_pictures_on_position"
  add_index "pictures", ["product_id"], :name => "index_pictures_on_product_id"

  create_table "points", :force => true do |t|
    t.integer  "value"
    t.integer  "user_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points", ["profile_id"], :name => "index_points_on_profile_id"
  add_index "points", ["user_id"], :name => "index_points_on_user_id"
  add_index "points", ["user_id"], :name => "temp_user_id"

  create_table "product_price_logs", :force => true do |t|
    t.integer  "product_id"
    t.decimal  "price",        :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "retail_price", :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model_number"
    t.string   "color_name"
    t.string   "color_sample"
    t.integer  "collection_id"
    t.boolean  "is_visible"
    t.string   "color_category"
    t.boolean  "is_kit",          :default => false
    t.string   "brand"
    t.string   "producer_code"
    t.string   "picture_for_xml"
    t.date     "launch_date"
  end

  add_index "products", ["category"], :name => "index_products_on_category"
  add_index "products", ["collection_id"], :name => "index_products_on_collection_id"
  add_index "products", ["color_category"], :name => "index_products_on_color_category"
  add_index "products", ["is_visible", "collection_id", "category"], :name => "index_products_on_is_visible_and_collection_id_and_category"
  add_index "products", ["is_visible"], :name => "index_products_on_is_visible"
  add_index "products", ["model_number"], :name => "index_products_on_model_number"

  create_table "products_profiles", :id => false, :force => true do |t|
    t.integer  "product_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products_profiles", ["product_id", "profile_id"], :name => "index_products_profiles_on_product_id_and_profile_id"
  add_index "products_profiles", ["product_id"], :name => "index_products_profiles_on_product_id"
  add_index "products_profiles", ["profile_id"], :name => "index_products_profiles_on_profile_id"

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_visit_banner"
    t.string   "alternative_name"
  end

  add_index "profiles", ["name"], :name => "index_profiles_on_name"

  create_table "promotion_actions", :force => true do |t|
    t.string   "type"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
  end

  create_table "promotion_rules", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "promotions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "starts_at"
    t.date     "ends_at"
    t.string   "checkout_banner"
  end

  create_table "questions", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "friend_title"
    t.integer  "survey_id"
  end

  create_table "related_products", :force => true do |t|
    t.integer  "product_a_id", :null => false
    t.integer  "product_b_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "related_products", ["product_a_id"], :name => "index_related_products_on_product_a_id"
  add_index "related_products", ["product_b_id"], :name => "index_related_products_on_product_b_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rule_parameters", :force => true do |t|
    t.text     "rules_params"
    t.integer  "promotion_rule_id"
    t.integer  "matchable_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "matchable_type"
  end

  add_index "rule_parameters", ["matchable_id", "matchable_type"], :name => "index_rule_parameters_on_matchable_id_and_matchable_type"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "shipping_companies", :force => true do |t|
    t.string   "name"
    t.string   "erp_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipping_services", :force => true do |t|
    t.string   "name"
    t.string   "erp_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cubic_weight_factor"
    t.integer  "priority"
    t.string   "erp_delivery_service"
  end

  create_table "simple_email_service_infos", :force => true do |t|
    t.integer  "bounces"
    t.integer  "complaints"
    t.integer  "delivery_attempts"
    t.integer  "rejects"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.date     "sent"
  end

  create_table "survey_answers", :force => true do |t|
    t.integer  "user_id"
    t.text     "answers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_answers", ["user_id"], :name => "index_survey_answers_on_user_id"

  create_table "surveys", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "synchronization_events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user"
  end

  create_table "trackings", :force => true do |t|
    t.integer  "user_id"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.string   "gclid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "placement"
    t.string   "referer"
  end

  add_index "trackings", ["user_id"], :name => "index_trackings_on_user_id"
  add_index "trackings", ["utm_content"], :name => "index_trackings_on_utm_content"

  create_table "user_credits", :force => true do |t|
    t.integer  "credit_type_id"
    t.integer  "user_id"
    t.decimal  "total",          :precision => 10, :scale => 0
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "user_credits", ["credit_type_id"], :name => "index_user_credits_on_credit_type_id"
  add_index "user_credits", ["user_id"], :name => "index_user_credits_on_user_id"

  create_table "user_infos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shoes_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dress_size"
    t.string   "t_shirt_size"
    t.string   "pants_size"
  end

  add_index "user_infos", ["user_id"], :name => "index_user_infos_on_user_id"

  create_table "user_liquidations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "liquidation_id"
    t.boolean  "dont_want_to_see_again", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_liquidations", ["liquidation_id"], :name => "index_user_liquidations_on_liquidation_id"
  add_index "user_liquidations", ["user_id"], :name => "index_user_liquidations_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.integer  "failed_attempts",                                 :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "encrypted_password",               :limit => 128, :default => "",    :null => false
    t.string   "invite_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "uid"
    t.text     "facebook_token"
    t.string   "cpf"
    t.boolean  "is_invited"
    t.date     "birthday"
    t.datetime "welcome_sent_at"
    t.boolean  "has_facebook_extended_permission"
    t.string   "authentication_token"
    t.boolean  "has_fraud"
    t.string   "facebook_permissions"
    t.boolean  "half_user",                                       :default => false
    t.integer  "gender"
    t.integer  "registered_via",                                  :default => 0
    t.datetime "campaign_email_created_at"
    t.string   "profile"
    t.string   "wys_uuid"
    t.string   "state"
    t.string   "city"
    t.string   "corporate_name"
    t.string   "cnpj"
    t.boolean  "reseller",                                        :default => false
    t.boolean  "active"
    t.boolean  "has_corporate"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token"
  add_index "users", ["cpf"], :name => "index_users_on_cpf"
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["half_user"], :name => "index_users_on_half_user"
  add_index "users", ["invite_token"], :name => "index_users_on_invite_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"
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
    t.boolean  "is_master"
    t.decimal  "width",             :precision => 8,  :scale => 2
    t.decimal  "height",            :precision => 8,  :scale => 2
    t.decimal  "length",            :precision => 8,  :scale => 2
    t.decimal  "weight",            :precision => 8,  :scale => 2
    t.decimal  "retail_price",      :precision => 10, :scale => 2
    t.integer  "discount_percent"
    t.integer  "initial_inventory",                                :default => 0
  end

  add_index "variants", ["is_master"], :name => "index_variants_on_is_master"
  add_index "variants", ["number"], :name => "index_variants_on_number"
  add_index "variants", ["product_id", "is_master"], :name => "index_variants_on_product_id_and_is_master"
  add_index "variants", ["product_id"], :name => "index_variants_on_product_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "video_relation_id"
    t.string   "video_relation_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "weights", :force => true do |t|
    t.integer "profile_id"
    t.integer "answer_id"
    t.integer "weight"
  end

  add_index "weights", ["answer_id"], :name => "index_weights_on_answer_id"
  add_index "weights", ["profile_id"], :name => "index_weights_on_profile_id"

end
