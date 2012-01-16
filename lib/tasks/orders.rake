# -*- encoding: utf-8 -*-
namespace :orders do
  desc "Cancel already expired billet payments."
  task :expires_billet, :output_file_path, :needs => :environment do |task, args|
    expires_billet = PaymentManager.new.expires_billet
    File.open("#{args[:output_file_path]}", 'w') do |f|
      f.puts expires_billet
    end
  end

  desc "Cancel already expired debit payments."
  task :expires_debit, :output_file_path, :needs => :environment do |task, args|
    expires_debit = PaymentManager.new.expires_debit
    File.open("#{args[:output_file_path]}", 'w') do |f|
      f.puts expires_debit
    end
  end
end

