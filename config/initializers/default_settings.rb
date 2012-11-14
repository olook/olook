Setting.defaults[:abacos_integrate] = true
Setting.defaults[:abacos_invetory] = true
Setting.defaults[:invite_credits_available] = true
Setting.defaults[:loyalty_program_credits_available] = true
Setting.defaults[:invite_credits_bonus_for_inviter] = "20.00"
Setting.defaults[:invite_credits_bonus_for_invitee] = "10.00"
Setting.defaults[:percentage_on_order] = "0.20"

Setting.defaults[:sac_beginning_working_hour] = "08:00:00"
Setting.defaults[:sac_end_working_hour] = "19:00:00"
Setting.defaults[:sac_purchase_amount_threshold] = "69.9"
Setting.defaults[:sac_total_discount_threshold_percent] = "60"
Setting.defaults[:sac_billet_subscribers] = "diogo.silva@olook.com.br,claudia.sardano@olook.com.br"
Setting.defaults[:sac_fraud_subscribers] = "diogo.silva@olook.com.br,marcelo.azevedo@olook.com.br"
Setting.defaults[:whitelisted_emails_only] = false
Setting.defaults[:mark_notified_users] = true
Setting.defaults[:send_in_cart_mail_locally] = false
Setting.defaults[:checkout_suggested_product_id]= "12472"
Setting.defaults[:braspag_whitelisted_only] = true
Setting.defaults[:braspag_percentage] = 10

Setting.defaults[:acquirer] = "redecard"
# Settings for in_cart_mail process
Setting.defaults[:in_cart_mail_range] = "1"
Setting.defaults[:in_cart_mail_how_long] = "1"
Setting.defaults[:in_cart_mail_condition] = "notified=0"

Setting.defaults[:quantity_for_sugested_product]= (1..5)
Setting.defaults[:send_to_clearsale] = true