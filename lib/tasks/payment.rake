# -*- encoding: utf-8 -*-
namespace :payments do
  desc "changes state names to the new phraseology"
  task :change_state_names => :environment do
    puts "Starting rake that changes state names to the new phraseology"
    state_hash = {"canceled" => "cancelled","under_analysis" => "under_review", "billet_printed" => "waiting_payment"}
    Payment.where(:state => state_hash.keys).find_each{|payment| payment.update_column(:state, state_hash[payment.state]) }
  end
end