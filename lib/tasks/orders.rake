# -*- encoding: utf-8 -*-
namespace :orders do
  desc "Cancel already expired billet payments."
  task :expires_billet => :environment do
    PaymentManager.new.expires_billet
  end

  desc "Cancel already expired credit card payments."
  task :expires_credit_card => :environment do
    PaymentManager.new.expires_credit_card
  end

  desc "Cancel already expired debit payments."
  task :expires_debit => :environment do
    PaymentManager.new.expires_debit
  end
end

