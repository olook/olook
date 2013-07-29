# -*- encoding : utf-8 -*-
class BilletService

  def self.process_billets(file_name)
    billet_numbers_array, successful_value = parse_file(file_name)
    sanitize_billets(billet_numbers_array, successful_value)
  end

  def self.save_file(file_content, file_name)
    fog_dir.files.create(key: file_name, body: file_content, public: false)

    File.open(File.expand_path(File.join("/tmp/", file_name)), 'w') { |f| f.write file_content }
  end

  def self.file_name
    "Billets-#{Date.today}-#{SecureRandom.uuid}.txt"
  end

  private

    def self.sanitize_billets billets_array, successful_value
      successful_array, unsuccessful_array = [],[]
      billets_array.each do |line_billet|
        billet_id = billet_info_id(line_billet)
        billet = Billet.find_by_id billet_id
        if billet.blank?
          unsuccessful_array << {id: billet_id, message: "Pedido não encontrado", order_number: ""}
        elsif billet.state != "waiting_payment"
          unsuccessful_array << {id: billet_id, message: "Estado '#{billet.state}' não elegível para autorização de pagamento", order_number: billet.try(:order).try(:number)}
        elsif billet && billet.try(:total_paid) != billet_info_value(line_billet)
          unsuccessful_array << {id: billet_id, message: "Valor pago não confere com o valor do boleto", order_number: billet.try(:order).try(:number)}
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

    def self.billet_info_id billet_info
      billet_info[27..38].to_i.to_s
    end

    def self.billet_info_value billet_info
      billet_info[98..107].gsub(' ','').gsub('.', '').gsub(',','.').to_d
    end

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
      file = fog_dir.files.get(billet_file_name)
      raise ArgumentError.new("File not Found on S3 #{billet_file_name}") unless file
      file.body
    end

    def self.file_path
      Rails.env.production? ? "/home/allinmail/retorno_santander/" : "#{Rails.root}/tmp/"
    end

    def self.change_comma_to_dot(value)
      value.gsub('.','').gsub(',','.').to_d
    end

    def self.fog_dir
      connection = Fog::Storage.new provider: 'AWS'
      dir = connection.directories.get('olook-batch-process')
      dir = connection.directories.create(key: 'olook-batch-process') unless dir
      dir
    end
end
