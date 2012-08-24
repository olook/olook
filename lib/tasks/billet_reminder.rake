# -*- encoding: utf-8 -*-
namespace :order do

  desc 'Send billet reminders email'
  task :send_billet_reminder => :environment do |task, args|
    SendBilletReminderWorker.perform
  end

end
