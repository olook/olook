# -*- encoding: utf-8 -*-
namespace :credit_type do

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

  desc 'Verify if user.credits.last.total = user.user_credits.first.total'
  task :verify => :environment do
    User.find_each do |user|

      if !user.credits.empty?
        if(user.credits.last.total.to_s != user.user_credits.first.total.to_s) 
          puts "#{user.id} :: #{user.credits.last.total} != #{user.user_credits.first.total}"
        end
      end

    end
  end
end
