#-*- enconding: utf-8 -*-
namespace :coupons do
  desc "Update old coupons with campaign_description == nil"
  task :update_old_coupons => :environment do
    Coupon.where(:campaign_description => nil).find_each do |coupon|
      campaign_description = "SEM CAMPANHA (VELHO PADRAO)"
      campaign = "SEM CAMPANHA (VELHO PADRAO)"
      coupon.update_attributes(:campaign => campaign, :campaign_description => campaign)
    end
    puts "--------------------------------All Done--------------------------------------------------"
  end
end
