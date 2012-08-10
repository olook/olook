# -*- encoding: utf-8 -*-
namespace :credit_type do

  desc 'Create Credit Types'
  task :create => :environment do #|task, args|
    LoyaltyProgramCreditType.create :code => "loyalty_program" 
    InviteCreditType.create :code => "invite"
    RedeemCreditType.create :code => "redeem"
  end

end
