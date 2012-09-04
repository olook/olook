# -*- encoding: utf-8 -*-
namespace :fidelidade do
  desc 'Create Credit Types'
  task :create => :environment do
    LoyaltyProgramCreditType.create :code => "loyalty_program" 
    InviteCreditType.create :code => "invite"
    RedeemCreditType.create :code => "redeem"
  end

  desc 'Assign all credits as InviteCreditType'
  task :migrate => :environment do
    Credit.find_each do |credit|
      begin
        uc = credit.user.user_credits_for(:invite)
        credit.update_attribute(:user_credit_id, uc.id)
      rescue Exception => e
        puts "\n"
        puts credit.id
        puts e.message
        puts "\n"
      end
    end
  end

  desc 'Verify if user.credits.last.total = user.user_credits.first.total. If not, correct.'
  task :verify_and_correct => :environment do
    User.find_each do |user|

      if !user.credits.empty?
        if(user.credits.last.total.to_s != user.user_credits.first.total.to_s)          
          puts "#{user.id} :: #{user.credits.last.total} != #{user.user_credits.first.total} - Correcting..."
          new_credit = user.credits.last.dup
          new_credit.value = ((user.user_credits.first.total * -1) + user.credits.last.total)
          new_credit.is_debit = (new_credit.value >= 0)? 0 : 1
          if new_credit.value < 0
            new_credit.value *= -1
          end
          new_credit.save
          puts "#{user.id} :: #{user.credits.last.total} == #{user.user_credits.first.total} - Corrected"
        end
      end
    end
  end
  
  desc "Update related users and address informations"
  task :update_metadata => :environment do |task, args|
    ActiveRecord::Base.transaction do
      
     Order.find_each do |order|
       p "#{order.id}"

      if order.user
        order.update_attributes!({
          :user_first_name  => order.user.first_name,
          :user_last_name   => order.user.last_name,
          :user_email       => order.user.email,
          :user_cpf         => order.user.cpf
        })
      end

      if order.freight && order.freight.address
        order.freight.update_attributes!({
          :country      => order.freight.address.try(:country),
          :city         => order.freight.address.try(:city),
          :state        => order.freight.address.try(:state),
          :complement   => order.freight.address.try(:complement),
          :street       => order.freight.address.try(:street),
          :number       => order.freight.address.try(:number),
          :neighborhood => order.freight.address.try(:neighborhood),
          :zip_code     => order.freight.address.try(:zip_code),
          :telephone    => order.freight.address.try(:telephone)
          })
        end
      end
    end 
  end
  
  desc "Update Moip Callbacks -> one way"
  task :update_moip_callbacks => :environment do |task, args|
    Payment.find_each do |payment|
      if payment.order && payment.order.cart_id
        payment.update_attribute(:cart_id, payment.order.cart_id)
      end
    end
    
    MoipCallback.find_each do |moip|
      if moip.order && moip.order.erp_payment
        moip.update_attribute(:payment_id, moip.order.erp_payment.id)
      end
    end
  end
  
  #WHEN START OPEN: http://www.youtube.com/watch?v=Dyx4v1QFzhQ
  
  desc "changes state names to the new phraseology"
  task :change_state_names => :environment do
    puts "Starting rake that changes state names to the new phraseology"
    state_hash = {"canceled" => "cancelled","under_analysis" => "under_review", "billet_printed" => "waiting_payment"}
    Payment.where(:state => state_hash.keys).find_each{|payment| payment.update_column(:state, state_hash[payment.state]) }
  end
  
  desc "move used coupon to payment"
  task :move_used_coupon_to_payment => :environment do
    puts "Starting rake move used coupon to payment"
    
    state_hash = {
      "authorized" => "authorized",
      "canceled" => "cancelled", 
      "delivered" => "authorized",
      "delivering" => "authorized",
      "picking" => "authorized",
      "reversed" => "reversed",      
      "waiting_payment" => "authorized"
    }
    
    UsedCoupon.find_each do |used_coupon|
      order = used_coupon.order
      coupon = used_coupon.coupon
      if order && coupon
        total_coupon =  0
        credits = order.credits
        credits ||= 0
        promotion = UsedPromotion.find_by_order_id(order.id).try(:discount_value)
        promotion ||= 0
        coupon_value = coupon.value
        
        total_coupon = order.amount_discount - credits - promotion
        
        if total_coupon <= 0
          amount_order = order.line_items.sum(:price) - credits - promotion

          amount_retail_order = order.line_items.sum(:retail_price) - credits - promotion
          amount_retail_order ||= amount_order
          amount_retail_order = amount_order if amount_retail_order == 0
          
          total_coupon = if coupon.is_percentage
            amount_retail_order * (coupon_value / 100)
          else
            max_value =  amount_retail_order - 5
            
            if coupon_value >= max_value
              coupon_value = max_value
            end
            
            coupon_value
          end
          
          
          # puts "\n#{order.id}\t amount_retail_order:#{amount_retail_order} \ttotal_coupon: #{total_coupon} \tcoupon_type: #{coupon.is_percentage} \tcoupon_value#{coupon.value}"
          
        end
        puts "\norder: #{order.id}\ttotal_coupon: #{total_coupon}\tcoupon: #{coupon.id}"
        
        coupon_payment = CouponPayment.create!(
                  :total_paid => total_coupon, 
                  :coupon_id => coupon.id,
                  :order => order)
        
        coupon_payment.update_column(:state, state_hash[order.state])
        
      end
    end
  end

  desc "move credits to payment"
  task :move_credits_to_payment => :environment do
    puts "Starting rake that moves the credits to payment"
    
    state_hash = {
      "authorized" => "authorized",
      "canceled" => "cancelled", 
      "delivered" => "authorized",
      "delivering" => "authorized",
      "picking" => "authorized",
      "reversed" => "reversed",      
      "waiting_payment" => "authorized"
    }
    credit_type_id = CreditType.find_by_code!(:invite).id
    Order.where('credits > ? AND credits IS NOT NULL', 0).find_each do |order|
        puts "\norder: #{order.id}\tcredits: #{order.credits}"
        
        credit_payment = CreditPayment.create!(
                  :total_paid => order.credits, 
                  :credit_type_id => credit_type_id , 
                  :order => order)
                                    
        
        credit_payment.update_column(:state, state_hash[order.state])
        
    end
  end
  
  
  desc "move promotion to payment"
  task :move_promotion_to_payment => :environment do
    puts "Starting rake that moves the promotion to payment"
    
    state_hash = {
      "authorized" => "authorized",
      "canceled" => "cancelled", 
      "delivered" => "authorized",
      "delivering" => "authorized",
      "picking" => "authorized",
      "reversed" => "reversed",      
      "waiting_payment" => "authorized"
    }
    UsedPromotion.find_each do |used_promotion|
      order = used_promotion.order
      promotion = used_promotion.promotion
      
      if order && promotion
        puts "\norder: #{order.id}\tpromotion: #{promotion.id} \tvalue:#{used_promotion.discount_value}"
        
        promotion_payment = PromotionPayment.create!(
          :total_paid => used_promotion.discount_value, 
          :promotion_id => promotion.id,
          :order => order,
          :discount_percent => used_promotion.discount_percent)
        
        promotion_payment.update_column(:state, state_hash[order.state])
      end
    end
  end
  
  desc "move olooklet/gift to payment"
  task :move_olooklet_gift_to_payment => :environment do
    puts "Starting rake that moves the olooklet / gift to payment"
    
    state_hash = {
      "authorized" => "authorized",
      "canceled" => "cancelled", 
      "delivered" => "authorized",
      "delivering" => "authorized",
      "picking" => "authorized",
      "reversed" => "reversed",      
      "waiting_payment" => "authorized"
    }
    
    Order.find_each do |order|
      total_for_gift = 0
      total_for_olooklet = 0

      order.line_items.each do |item|
        delta = (item.price - item.retail_price)
        #existe desconto
        if delta > 0
          if item.gift
            total_for_gift += delta
          else
            total_for_olooklet += delta
          end
        end
      end
      
      #RETIRAR VALOR DO CuponPayment + PromotionPayment
      
      payments_for_discount = order.payments.where(:payments => {:type => ['PromotionPayment', 'CouponPayment']})
      
      difference = 0

      payments_for_discount.each do |payment|
        if payment.kind_of? PromotionPayment
          difference += payment.total_paid 
        else
          difference += payment.total_paid if payment.coupon.is_percentage
        end
      end
      
      total_for_gift -= difference
      total_for_olooklet -= difference
      
      puts "\norder: #{order.id}\ttotal_for_gift: #{total_for_gift} \ttotal_for_olooklet: #{total_for_olooklet}"

      if total_for_gift > 0
        gift_payment = GiftPayment.create!(
                  :total_paid => total_for_gift, 
                  :order => order)

        gift_payment.update_column(:state, state_hash[order.state])
      end

      if total_for_olooklet > 0
        olooklet_payment = OlookletPayment.create!(
                  :total_paid => total_for_olooklet, 
                  :order => order)

        olooklet_payment.update_column(:state, state_hash[order.state])
      end
    end
  end
  
  desc "populate gross amount"
  task :populate_gross_amount => :environment do
    puts "Starting rake that populate gross amount"
    gift_wrap = CartService.gift_wrap_price
    Order.find_each do |order|
      gross_amount = order.line_items.sum(:price)
      gross_amount += order.freight.price if order.freight
      gross_amount += gift_wrap if order.gift_wrap
      
      order.update_column(:gross_amount, gross_amount)
    end
  end
  
end

