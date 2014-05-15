class ProductIndexer
  include Search::Indexer
  extend Fixes
  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]

  def initialize(entities, adapter)
    @entities = entities
    @adapter = adapter
    @config = SEARCH_CONFIG
  end

  protected

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

  def add_documents
    entities.each_slice(500).with_index do |slice, index|
      run(sdf_entries(entities_to_index(slice)), index)
    end
  end

  def remove_documents
    flush_to_sdf_file "/tmp/base-remove.sdf", sdf_entries(entities_to_remove(entities), 'delete')
    upload_sdf_file "/tmp/base-remove.sdf"
  end

  def send_failure_mail e
    opts = {
      body: "Falha ao gerar o arquivo para indexacao: #{index}-add<br> #{e} <br> #{e.backtrace}",
      to: "tech@olook.com.br",
        subject: "Falha ao rodar a indexacao de produtos"}
    DevAlertMailer.notify(opts).deliver
  rescue
    # It should not fail process because the email send
  end

end
