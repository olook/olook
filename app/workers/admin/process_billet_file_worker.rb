# -*- encoding : utf-8 -*-
class Admin::ProcessBilletFileWorker
  @queue = :process_billet_file

  def self.perform
    processed_orders = process_orders(parse_file)
    send_notification processed_orders
  end

  private
    def file_path
      Rails.env.production? ? "to be defined" : Rails.root+"/tmp/"  
    end

    def filename
      "teste.txt"  
    end  

    def read_file
      File.open("#{file_path}#{filename}", "r").read
    end

    def parse_file
      file_content = read_file
      # TODO parse file and return the order number lines array
      { sucessful:[], unsuccesful:[] } 
    end

    def process_orders order_numbers_array 
      # for each order number line
        # check if valor_titulo, valor_pago == Billet.total_paid for the given order number
        # if so, change order status to paid

      # return processed_orders_array
      []
    end

    def send_notification
      # send summary email
    end
end
