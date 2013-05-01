# -*- encoding : utf-8 -*-
class BilletService

  def self.process_billets(file_name)
    successful_array, unsuccessful_array = [],[]
    billet_numbers_array, successful_value = parse_file(file_name)
    billet_numbers_array.each do |line_billet|
    billet_id = line_billet[27..38].to_i.to_s

      billet = Billet.find_by_id billet_id
      if billet.blank?
        unsuccessful_array << {id: billet_id, message: "Pedido não encontrado", order_number: ""}
      elsif billet.state != "waiting_payment"
        unsuccessful_array << {id: billet_id, message: "Estado '#{billet.state}' não elegível para autorização de pagamento", order_number: billet.try(:order).try(:number)}
      elsif billet && billet.try(:total_paid) != line_billet[58..69].gsub(' ','').gsub(',','.').to_d
        unsuccessful_array << {id: billet_id, message: "Valor pago não confere com o valor do boleto", order_number: billet.try(:order).try(:number)}
      elsif line_billet[58..69].gsub(',','.').to_d > line_billet[98..107].gsub(',','.').to_d
        unsuccessful_array << {id: billet_id, message: "Valor pago é menor que o valor do título", order_number: billet.try(:order).try(:number)}
      else
        begin
          billet.authorize
          successful_array << {id: billet_id, message: "OK", order_number: billet.try(:order).try(:number)}
        rescue => e
          Airbrake.notify(
            :error_class   => "Admin::ProcessBilletFileWorker",
            :error_message => "process_billets: the following error occurred: #{e.message}"
          )
          unsuccessful_array << {id: billet_id, message: "Problema na transição de status do boleto"}
        end
      end
    end
    { successful: successful_array, unsuccessful: unsuccessful_array, successful_value: successful_value }
  end


  def self.save_file(file_content, file_name)
    MarketingReports::FileUploader.new(file_name, file_content).save_local_file
    MarketingReports::FileUploader.copy_file(file_name, "/home/allinmail/retorno_santander") if Rails.env.production?
  end

  def self.file_name
    "Billets-#{Date.today}-#{SecureRandom.uuid}.txt"
  end

  private
    def self.parse_file(billet_file_name)
      file_content = read_file(billet_file_name)
      file_content.gsub!(/\r\n?/, "\n");
      line_array = file_content.split("\n")
      lines = line_array.select{|line| line.match('T LIQ')}
      payments_control = lines.inject(0) {|total, line| total += change_comma_to_dot line[98..107]}
      payments_total = change_comma_to_dot line_array.select{|line| line.match('TOTAL')}.first[98..107]
      [lines, payments_control == payments_total]
    end

    def self.read_file(billet_file_name)
      File.open("#{file_path}#{billet_file_name}", "r").read
    end

    def self.file_path
      Rails.env.production? ? "/home/allinmail/retorno_santander/" : "#{Rails.root}/tmp/"
    end

    def self.change_comma_to_dot(value)
      value.gsub('.','').gsub(',','.').to_d
    end
end
