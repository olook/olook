desc "Populate missing debit operations and reason descriptions for credits"
namespace :olook do

  task :populate_debit_operations, :needs => :environment do
  	Credit.find_each do |credit|
  		if credit.source.include?("debit")
        reason = Order.find(credit.order_id).number unless credit.order_id == nil    
  			credit.is_debit = true
        credit.reason = "Order #{reason} received"
  			credit.save
  		elsif credit.source.include?("credit")
        reason = Order.find(credit.order_id).number unless credit.order_id == nil  
        credit.reason = "Order #{reason} canceled"
        credit.save
      end
  	end
  end

  task :populate_reason, :needs => :environment do 
    Credit.find_each do |credit|
      if credit.source.include?("inviter")
        if credit.user != nil
          if credit.user.inviter != nil
            credit.reason = "Accepted invite from #{credit.user.inviter.name.camelize}"
            credit.save
          end
        end
      elsif credit.source.include?("invitee")
        if credit.order != nil
          if credit.order.user != nil
            credit.reason = "#{credit.order.user.name.camelize} first buy"
            credit.save
          end
        end
      end
    end
  end

end