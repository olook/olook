# -*- encoding : utf-8 -*-
class Admin::ProcessBilletFileWorker
  @queue = :process_billet_file

  def self.perform
    processed_billets = process_billets(parse_file)
    send_notification processed_billets
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

    def self.process_billets billet_numbers_array
      successful_array, unsuccessful_array = [],[]
      billet_numbers_array.each do |line_billet|
        billet_id = line_billet[27..38].to_i.to_s

        billet = Billet.find_by_id billet_id
        if billet.blank?
          unsuccessful_array << {id: billet_id, message: "Pedido não encontrado"}
        elsif billet.state != "waiting_payment"
          unsuccessful_array << {id: billet_id, message: "Estado '#{billet.state}' não elegível para autorização de pagamento"}        
        elsif billet && billet.try(:total_paid).to_s != line_billet[58..69].gsub(' ','').gsub(',','.')
          unsuccessful_array << {id: billet_id, message: "Valor pago não confere com o valor do boleto"}
        elsif line_billet[58..69].gsub(' ','') != line_billet[98..107].gsub(' ','')
          unsuccessful_array << {id: billet_id, message: "Valor pago não confere com o valor do título"}
        else
          begin
            # billet.authorize
            successful_array << {id: billet_id, message: "OK"}
          rescue => e
            Airbrake.notify(
              :error_class   => "Admin::ProcessBilletFileWorker",
              :error_message => "process_billets: the following error occurred: #{e.message}"
            )       
            unsuccessful_array << {id: billet_id, message: "Problema na transição de status do boleto"}
          end
        end
      end
      { successful: successful_array, unsuccessful: unsuccessful_array }
    end

    def self.send_notification processed_billets
      # send summary email
    end
end
