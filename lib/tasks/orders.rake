# -*- encoding: utf-8 -*-
namespace :orders do
  desc "Cancel already expired billet payments."
  task :expire_billet => :environment do
  end
  desc "Cancel already expired debit payments."
  task :expire_debit => :environment do
  end
  desc "Cancel already expired creditcard payments."
  task :expire_creditcard => :environment do
  end
end
