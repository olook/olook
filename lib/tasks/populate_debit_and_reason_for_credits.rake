desc "Populate missing debit operations and reason descriptions for credits"
namespace :credit do

  task :populate_debit_operations => :environment do
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

  task :populate_invitees_reason_for_credit => :environment do 
    Credit.where("source = 'inviter_bonus' AND reason = '' ").each do |credit|
      if credit.user != nil
        reason = credit.user.inviter ? "Accepted invite from #{credit.user.inviter.name.camelize}" : "Inviter account has been removed"
        credit.reason = reason
        credit.save
      end
    end
  end

  task :populate_inviters_reason_for_credit => :environment do
    Credit.where("source = 'invitee_bonus' AND reason = '' ").each do |credit|
      if credit.order != nil
        reason = credit.order.user ? "#{credit.order.user.name.camelize} first buy. Order number: #{credit.order.number}" : "Invitee account has been removed"
        credit.reason = reason
        credit.save
      end
    end
  end

end