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

  desc "Update the order status"
  task :update_status => :environment do |task, args|
    Resque.enqueue(Abacos::UpdateOrderStatus)
  end

  desc "Update related users and address informations"
  task :update_metadata => :environment do |task, args|
    ActiveRecord::Base.transaction do
      
     Order.find_each do |order|
       p "#{order.id}"

      if order.user
        order.update_attributes!({
          :user_first_name  => order.user.first_name,
          :user_last_name   => order.user.last_name,
          :user_email       => order.user.email,
          :user_cpf         => order.user.cpf
        })
      end

      if order.freight && order.freight.address
        order.freight.update_attributes!({
          :country      => order.freight.address.try(:country),
          :city         => order.freight.address.try(:city),
          :state        => order.freight.address.try(:state),
          :complement   => order.freight.address.try(:complement),
          :street       => order.freight.address.try(:street),
          :number       => order.freight.address.try(:number),
          :neighborhood => order.freight.address.try(:neighborhood),
          :zip_code     => order.freight.address.try(:zip_code),
          :telephone    => order.freight.address.try(:telephone)
          })
        end
      end
    end 
  end
  
  desc "Update Moip Callbacks -> one way"
  task :update_moip_callbacks => :environment do |task, args|
    Payment.find_each do |payment|
      if payment.order && payment.order.cart_id
        payment.update_attribute(:cart_id, payment.order.cart_id)
      end
    end
    
    MoipCallback.find_each do |moip|
      if moip.order && moip.order.payment
        moip.update_attribute(:payment_id, moip.order.payment.id)
      end
    end
  end
  
end

