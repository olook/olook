namespace :braspag do

  FILE_PATH = "#{Rails.root}/tmp/braspag_report.csv"

  desc "Generating report of all authorized Braspag transactions"
  task :create_report => :environment do

    puts "Writing file..."
    File.open(FILE_PATH, 'w') do |f|
      BraspagCaptureResponse.where(status: 0).each do |braspag_capture_response|
        payment = Payment.find_by_identification_code(braspag_capture_response.identification_code)
        if payment
          f.puts("#{braspag_capture_response.acquirer_transaction_id};#{payment.total_paid.to_s};#{payment.payments.to_s};#{payment.created_at.strftime("%d/%m/%Y")}\n")
          f.flush
        else
          puts "BraspagCaptureResponse ID:#{braspag_capture_response.id} doesn't have a payment."
        end
      end
    end

    puts "File #{FILE_PATH} generated."

  end

end