#-*- enconding: utf-8 -*-
namespace :coupons do
  desc "Update old coupons with campaign_description == nil"
  task :update_old_coupons => :environment do
    Coupon.where(:campaign => nil).find_each do |coupon|
      coupon.campaign = "PADRAO ANTIGO (SEM CAMPANHA)"
      coupon.campaign_description = "PADRAO ANTIGO (SEM CAMPANHA)"
      coupon.created_by = "FELIPE"
      coupon.save(:validate => false)
    end
    puts "--------------------------------All Done--------------------------------------------------"
  end
end
