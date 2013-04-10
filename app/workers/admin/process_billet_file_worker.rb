# -*- encoding : utf-8 -*-
class Admin::ProcessBilletFileWorker
  @queue = :process_billet_file

  def self.perform
    processed_orders = process_orders(parse_file)
    send_notification processed_orders
  end

  private
    def self.file_path
      Rails.env.production? ? "to be defined" : "#{Rails.root}/tmp/"
    end

    def self.filename
      "teste.txt"  # Maybe we should create a filename using a UUID hash and pass it as a parameter @ perform
    end

    def self.read_file
      File.open("#{file_path}#{filename}", "r").read
    end

    def self.parse_file
      file_content = read_file
      line_array = file_content.split("\r\n")
      start_line = 0
      end_line = 0

      line_array.each_with_index do |line, index|
        start_line = index+1 if line.include? "CUSTAS (C)"
        end_line = index-1 if line.include? "TOTAL"
      end

      line_array[start_line..end_line]
    end

    def self.process_orders order_numbers_array
      sucessful_array, unsuccesful = [],[]
      order_numbers_array.each do |line_order|
        order = Order.find line_order[32..38]
        if line_order[60..75].gsub(' ','') == line_order[100..110].gsub(' ','')
          if order && order.try(:amount_paid) == line_order[60..75].gsub(' ','')

          end
        else
          # ENVIAR que o boleto não foi pago totalmente
        end
      end
      # for each order number line
        # check if valor_titulo, valor_pago == Billet.total_paid for the given order number
        # if so, change order status to paid

      # return processed_orders_array
      { sucessful: [], unsuccesful: [] }
    end

    def self.send_notification processed_orders
      # send summary email
    end
end
