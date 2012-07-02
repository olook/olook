# -*- encoding: utf-8 -*-
namespace :order do

  desc 'Send billet reminders email'
  task :send_billet_reminder => :environment do |task, args|
    BilletNotifier.send_reminder.each do | reminder |
      reminder.deliver
    end
  end

end
