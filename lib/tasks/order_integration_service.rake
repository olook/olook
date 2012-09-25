namespace :order_integration_service do
  desc "Insert order on Abacos synchronously"
    task :insert_order, [:number] => :environment do |t, args|
      Abacos::InsertOrder.perform(args[:number])
    end
  desc "Confirm payment on Abacos synchronously"
    task :confirm_payment, [:number] => :environment do |t, args|
      Abacos::ConfirmPayment.perform(args[:number])
    end
end