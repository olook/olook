# -*- encoding : utf-8 -*-
Setting.defaults[:abacos_integrate] = true
Setting.defaults[:abacos_invetory] = true
Setting.defaults[:invite_credits_available] = true
Setting.defaults[:loyalty_program_credits_available] = true
Setting.defaults[:invite_credits_bonus_for_inviter] = "20.00"
Setting.defaults[:invite_credits_bonus_for_invitee] = "10.00"
Setting.defaults[:percentage_on_order] = "0.20"
Setting.defaults[:billet_discount_available] = true
Setting.defaults[:billet_discount_percent] = 3
Setting.defaults[:debit_discount_available] = true
Setting.defaults[:debit_discount_percent] = 3

Setting.defaults[:sac_beginning_working_hour] = "08:00:00"
Setting.defaults[:sac_end_working_hour] = "19:00:00"
Setting.defaults[:sac_purchase_amount_threshold] = "69.9"
Setting.defaults[:sac_total_discount_threshold_percent] = "60"
Setting.defaults[:sac_billet_subscribers] = "caroline.passos@olook.com.br"
Setting.defaults[:sac_fraud_subscribers] = "caroline.passos@olook.com.br"
Setting.defaults[:whitelisted_emails_only] = false
Setting.defaults[:mark_notified_users] = true
Setting.defaults[:send_in_cart_mail_locally] = false
Setting.defaults[:checkout_suggested_product_id]= "12472"

Setting.defaults[:cheirinho_de_graca] = false

Setting.defaults[:acquirer] = "redecard"
# Settings for in_cart_mail process
Setting.defaults[:in_cart_mail_range] = "1"
Setting.defaults[:in_cart_mail_how_long] = "1"
Setting.defaults[:in_cart_mail_condition] = "notified=0"


Setting.defaults[:quantity_for_sugested_product]= (1..5)

# Gifts page
Setting.defaults[:profile_moderna_product_ids] = "4999,5759,3515,4352,7759"
Setting.defaults[:profile_casual_product_ids] = "9950,7434,7425,7001,6023"
Setting.defaults[:profile_chic_product_ids] = "6727,4963,5008,9896,9081"
Setting.defaults[:profile_sexy_product_ids] = "5044,5017,10022,4350,9406"

# ClearSale
Setting.defaults[:send_to_clearsale] = false
Setting.defaults[:force_send_to_clearsale] = false
Setting.defaults[:use_clearsale_server] = false

# General configs
Setting.defaults[:show_campaign_email_modal] = true

# First Purchase Discount Dates
Setting.defaults[:recommended_products] = "11101"
Setting.defaults[:default_item_quantity] = 10

Setting.defaults[:use_vwo] = false

Setting.defaults[:profile_users] = "nelson.haraguchi@olook.com.br,luis.daher@olook.com.br,rafael.manoel@olook.com.br,vinicius.monteiro@olook.com.br,tiago.almeida@olook.com.br,rafael.carvalho@olook.com.br,oliver.barnes@olook.com.br,thaiane.gazzi@olook.com.br"

# format: YYYY-MM-DD
Setting.defaults[:lower_limit_source_csv] = "2013-03-26"

#Showroom pages (clothes)
Setting.defaults[:cloth_showroom_moderna] = "91015,91127,90815,91325,90787"
Setting.defaults[:cloth_showroom_casual] = "91209,91201,91163,90839,90791"
Setting.defaults[:cloth_showroom_chic] = "91441,91417,90823,90751,91301"
Setting.defaults[:cloth_showroom_sexy] = "90863,91293,91349,90947,91381"

# Santander billet
Setting.defaults[:santander_billet] = false

Setting.defaults[:lightbox_coupon_code] = "WP1HYH1JUL13"
Setting.defaults[:olookmovel_coupon_code] = "WP1HYH1JUL13"
Setting.defaults[:valentines_day_coupon_code] = "NAMORADOS13ALL"
Setting.defaults[:valentines_day_show_modal] = "0"
Setting.defaults[:billet_summary_email] = "tiago.almeida@olook.com.br"
Setting.defaults[:unused_sessions_email] = "tech@olook.com.br"
Setting.defaults[:blacklisted_users] = "arte-1818@hotmail.com"

Setting.defaults[:show_checkout_banner] = true
Setting.defaults[:show_search_field] = false
Setting.defaults[:show_product_partner_tags] = true

#Antibounce settings
Setting.defaults[:antibounce_product_lines] = 4
Setting.defaults[:antibounce_enabled] = true

Setting.defaults[:upload_marketing_files_to_s3] = true

# Smart Catalogs
Setting.defaults[:inventory_weight] = 1
Setting.defaults[:age_weight] = 1

Setting.defaults[:enable_neoassist] = false

Setting.defaults[:disable_ab_test_for_look_products] = false

Setting.defaults[:complete_look_promotion_id] = "0"

Setting.defaults[:look_cloth_category_weight] = 2
Setting.defaults[:look_shoe_category_weight] = 1
Setting.defaults[:look_bag_category_weight] = 1
Setting.defaults[:look_accessory_category_weight] = 1

Setting.defaults[:sample_popup_url] = "<script type=\"text/javascript\" src=\"http://popup.olook.com.br/js.php?popup=6\"></script>"
Setting.defaults[:mercadolivre_product_ids] = "18541,18519,18539,18537,18525,18543,18527,18555,18557,18567,18531,18561,18547,18535,18553,18533,18569,18529,18559,18545,18890,18551,18549,18515,14628,17689,18517,14626,21987,18914,18916,14624,14644,15870,18874,22009,18882,1748010017,14630,14616,3220,4380,11533,14086,17822,18751,18753,19571,19573,19575,19577,19992,20006,20044,20074,20076,20088,20122,20144,20600,20606,20899,20901,21359,21391,21395,21403,21407,21419,21421,22350,22352,22597,22601,22617,22623,22625,22627,22629,22883,22887,22889,22891,22893,22895,22897,22899,22901,22903,22913,22915,22917,22919,90370,7069,13213,14552,14596,14634,14638,14640,14646,14654,14662,14674,14764,17708,18229,18511,18565,18866,18872,18910,21371,21989,21995"

Setting.defaults[:dev_notification_emails] = 'rafael.manoel@olook.com.br,tiago.almeida@olook.com.br,nelson.haraguchi@olook.com.br,luis.daher@olook.com.br'
Setting.defaults[:superfast_shipping_enabled] = true
Setting.defaults[:billet_days_to_expire] = 2

begin
  MktSetting.save_default(:facebook_products, "1703103190,1584034001,1525034002")
rescue
  Rails.logger.info("nao foi possivel inserir as propriedades de marketing")
end
