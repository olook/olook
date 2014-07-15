module Search
  module Indexer
    attr_reader :entities, :adapter

    def index
      add_documents
      remove_documents
      
      csv_content = CSV.generate(col_sep: ';') do |csv|
        csv << ['id', 'category', 'age', 'inventory', 'brand', 'exp']
        @adapter.log.each {|log_line| csv << log_line}  
      end     

      File.open("ranking.csv", "w") {|f| f << csv_content}
      
    end

    protected

    def create_sdf_entry_for(entity, type)
      document = @adapter.adapt(entity,type)
      document.to_document
    end

    def sdf_entries(entities, type)
      entities.map do |entity| 
        begin
          d1 = Time.zone.now
          entry = create_sdf_entry_for(entity, type) 
          d2 = Time.zone.now
          Rails.logger.info "Tempo: #{(d2 - d1) * 1000}s"
          entry
        rescue => e
          Airbrake.notify(e,
            :error_class   => "Indexer",
            :error_message => "sdf entry é nulo",
            :backtrace => nil
          )          
        end
      end.compact
    end

    def add_documents
      entities.each_slice(500).with_index do |slice, index|
        Rails.logger.info("[INDEXER] index:#{index}")
        documents = sdf_entries(entities_to_index(slice), 'add')
        save(documents, index)
        Rails.logger.info("[INDEXER] sdf file sent to amazon")
      end
    end

    def remove_documents
      flush_to_sdf_file "/tmp/base-remove.sdf", sdf_entries(entities_to_remove(entities), 'delete')
      upload_sdf_file "/tmp/base-remove.sdf"
    end

    def flush_to_sdf_file file_name, all_documents
      File.open(file_name, "w:UTF-8") do |file|
        file.puts all_documents.to_json
      end
    end

    def save(documents, index)
      begin
        file_name = "/tmp/base-add#{'%03d' % index}.sdf"
        flush_to_sdf_file(file_name, documents)
        upload_sdf_file file_name
      rescue => e
        Rails.logger.error("Erro ao enviar para amazon: #{e.class}, #{e.message}\n#{e.backtrace.join("\n")}")
        send_failure_mail e
      end
    end

    def upload_sdf_file file_name
      # docs_domain = @config["docs_domain"]
      # api_version = @config["api_version"]
      # result = `curl -s -X POST --upload-file "#{file_name}" "#{docs_domain}"/"#{api_version}"/documents/batch --header "Content-Type:application/json"`

      # errors = JSON.parse(result)['errors']
      # if errors
      #   Rails.logger.info("Erro no arquivo #{file_name}: #{errors.map{|a| a.values.first.split(/\(near/).first}.uniq}")
      #   raise "Erros no arquivo #{file_name} #{errors.inspect}" unless Rails.env.production?
      # end
      # result
    end

    def send_failure_mail e
    end
  end
end
