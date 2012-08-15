# -*- encoding: utf-8 -*-
namespace :orders do
  desc "Cancel already expired billet payments."
  task :expires_billet, [:output_file_path] => :environment do |task, args|
    expires_billet = PaymentManager.new.expires_billet
    File.open("#{args[:output_file_path]}", 'w') do |f|
      f.puts expires_billet
    end
  end

  desc "Cancel already expired debit payments."
  task :expires_debit, [:output_file_path] => :environment do |task, args|
    expires_debit = PaymentManager.new.expires_debit
    File.open("#{args[:output_file_path]}", 'w') do |f|
      f.puts expires_debit
    end
  end
  
  desc "Update ERP STATUS -> only one"
  task :update_erp_status => :environment do |task, args|
    Order.find_each do |order|
      if order.erp_integrate_at.nil?
        integrate_at = order.order_events.where(:message => "Calling Abacos::InsertOrder").first
        unless integrate_at.nil?
          order.update_attribute(:erp_integrate_at, integrate_at.updated_at)
        else
          order.update_attribute(:erp_integrate_at, order.created_at)
        end
      end
      
      if order.erp_cancel_at.nil?
        canceled_at = order.order_state_transitions.where(:to => "canceled").first
        unless canceled_at.nil?
          order.update_attribute(:erp_cancel_at,  canceled_at.created_at)
        end
      end
      
      if order.erp_payment_at.nil? && order.payment
        payment_at = order.order_events.where(:message => "Calling Abacos::ConfirmPayment").first
        unless payment_at.nil?
          order.update_attribute(:erp_payment_at, payment_at.updated_at)
        end
      end
    end
  end

  desc "Update the order status"
  task :update_status => :environment do |task, args|
    Resque.enqueue(Abacos::UpdateOrderStatus)
  end
end

