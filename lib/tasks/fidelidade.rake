# -*- encoding: utf-8 -*-
namespace :fidelidade do

  desc "give credits to users that sucessfully purchased products from september 1st to september 13th"
  task :retroactively_give_loyalty_credits => :environment do
    Order.where("orders.state in ('authorized','delivering','delivered','picking')")
         .where("orders.created_at between '2012-09-01' and '2012-09-14'").each do |order|
      credits_for_order = order.user
                               .user_credits_for(:loyalty_program)
                               .credits.where(:order_id => order, :source => "loyalty_program_credit")
                               .count
      UserCredit.add_loyalty_program_credits(order) if credits_for_order == 0
    end
  end
end

