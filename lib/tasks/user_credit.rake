# -*- encoding: utf-8 -*-
namespace :credit_type do

  desc 'Create Credit Types'
  task :create => :environment do #|task, args|
    LoyaltyProgramCreditType.create :code => "loyalty_program" 
    InviteCreditType.create :code => "invite"
    RedeemCreditType.create :code => "redeem"
  end

  desc 'Assign all credits as InviteCreditType'
  task :migrate => :environment do
     Credit.all.find_each do |credit|
     	uc = credit.user.user_credits_for(:invite)
     	credit.update_attribute :user_credit_id => uc.id
     end
  end

end
