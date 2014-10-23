class ProductIndexer
  include Search::Indexer
  extend Fixes

  def initialize(entities, adapter)
    @entities = entities
    @adapter = adapter
    @config = Search::Config
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
