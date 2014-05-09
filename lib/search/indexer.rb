module Search
  class Indexer
    extend Fixes
    SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]    

    attr_reader :entities, :adapter

    def initialize(entities, adapter)
      @entities = entities
      @adapter = adapter
    end

    def index
      add_documents
      remove_documents  
    end

    protected

      def flush_to_sdf_file file_name, all_documents
        File.open("#{file_name}", "w:UTF-8") do |file|
          file << all_documents.to_json
        end
      end

      def entities_to_index(entity_ids)
        _products = Product.where(id: entity_ids).where('price > 0').includes(:pictures, :variants, :details, :collection, :collection_themes).all
        _products.select! {|p| p.main_picture && p.main_picture[:image] }
        _products
      end

      def entities_to_remove(entity_ids)
        _products = Product.where(price: 0).where(id: entity_ids).includes(:pictures).all
        _products.select! {|p| p.main_picture.nil? || p.main_picture[:image].nil? }
        _products
      end

      def create_sdf_entry_for(entity, type)
        document = @adapter.adapt(entity,type)
        document.to_document    
      end

      def upload_sdf_file file_name
        docs_domain =  SEARCH_CONFIG["docs_domain"]
        `curl -s -X POST --upload-file "#{file_name}" "#{docs_domain}"/2011-02-01/documents/batch --header "Content-Type:application/json"`
      end

      def add_documents
        entities.each_slice(500).with_index do |slice, index|
          run slice, index
        end
      end

      def remove_documents
        flush_to_sdf_file "/tmp/base-remove.sdf", sdf_entries(entities_to_remove(entities), 'delete')
        upload_sdf_file "/tmp/base-remove.sdf"
      end

      def run(slice, index)
        begin
          file_name = "/tmp/base-add#{'%03d' % index}.sdf"
          flush_to_sdf_file file_name, sdf_entries(entities_to_index(slice), 'add')
          upload_sdf_file file_name
        rescue => e
          send_failure_mail e.backtrace
        end
      end

      def send_failure_mail backtrace
        opts = {
          body: "Falha ao gerar o arquivo para indexacao: #{index}-add<br> #{e} <br> #{e.backtrace}",
          to: "tech@olook.com.br",
          subject: "Falha ao rodar a indexacao de produtos"}
        DevAlertMailer.notify(opts).deliver        
      end

      def sdf_entries(entities, type)
        entities.map { |entity| create_sdf_entry_for(entity, type) }.compact
      end
  end
end