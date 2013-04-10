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
      successful_array, unsuccessful_array = [],[]
      order_numbers_array.each do |line_order|
        order = Order.find_by_number line_order[32..38]
        if order.blank?
          unsuccessful_array << {number: line_order[32..38], message: "Pedido não encontrado"}
        elsif order && order.try(:amount_paid).to_s != line_order[58..69].gsub(' ','').gsub(',','.')
          unsuccessful_array << {number: line_order[32..38], message: "Valor pago não confere com o valor do pedido"}
        elsif line_order[58..69].gsub(' ','') != line_order[98..107].gsub(' ','')
          unsuccessful_array << {number: line_order[32..38], message: "Valor pago não confere com o valor do título"}
        else
          # change order and payment state
          successful_array << {number: line_order[32..38], message: "OK"}
        end
      end
      { successful: successful_array, unsuccessful: unsuccessful_array }
    end

    def self.send_notification processed_orders
      # send summary email
    end
end
