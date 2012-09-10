# -*- encoding: utf-8 -*-
namespace :users do

  desc "Send in the card email"
  task :send_incart_emails => :environment do |task, args|
    SendInCartEmailWorker.perform
  end

end

