# -*- encoding : utf-8 -*-
class KanuiIntegration
  KEY = 'KANUI'
  LIST_KEY = 'KANUI:LIST'
  ACTIVE_KEY = 'KANUI:ACTIVE'
  HEADERS = ["Esporte", "Tipo de Produto", "Marca", "Gênero", "Cor Fornecedor", "Modelo", "Nome", "Código Fornecedor( Produto)", "Tamanho", "EAN (CÓDIGO DE BARRAS)", "Custo CIF (Valor do Produto + IPI)", "Preço de Venda (sugerido pelo fornecedor)", "Fornecedor", "Origem - Nacional / Importado", "Linha de Produto", "Tipo de Armazenamento", "Cor Padrão", "Cores do Produto", "Material (ex.: 50% Algodão e 50% Poliéster)", "Material (ex.: Algodão, Poliéster)", "Composição do material Interno", "Clubes", "Estilo", "Características Gerais", "Breve Descrição do Tamanho", "Acabamento", "Capacidade", "Medidas do Produto",  "Altura do Produto", "Largura do Produto", "Comprimento do Produto", "Peso do Produto", "Aplicação", "Necessita Montagem?", "Garantia de Fornecedor", "Descrição", "Descrição Breve", "O que o Produto Contém", "Instruções/ Cuidados"]

  def initialize(options={})
    @redis = options.delete(:redis) || Redis.connect(url: ENV['REDIS_LEADERBOARD'])

    if options[:list]
      @redis.del(LIST_KEY)
      @redis.rpush(LIST_KEY, options[:list]) 
    end

    @redis.set(ACTIVE_KEY, options[:active]) unless options[:active].nil?
  end

  def run
    if @redis.get(ACTIVE_KEY)
      csv = generate_csv
      send_email_with(csv).deliver
    end
  end

  def enable
    @redis.set(ACTIVE_KEY, true)
  end

  def disable
    @redis.set(ACTIVE_KEY, false)
  end

  def product_ids
    @redis.lrange(LIST_KEY, 0, -1)
  end

  def enabled?
    @redis.get(ACTIVE_KEY) == "true"
  end

  private
    def generate_csv
      product_ids = @redis.lrange(LIST_KEY, 0, -1)
      products = Product.where(id: product_ids).includes(:variants)

      CSV.generate(col_sep: ';') do |csv|
        csv << HEADERS
        products.each do |product|
          product.variants.each do |variant|
            csv << generate_csv_line(product, variant)
          end
        end
      end
    end

    def send_email_with(csv)
      DevAlertMailer.kanui_email(csv)
    end

    def generate_csv_line(product, variant)
      ["", product.subcategory, product.brand, "feminino", product.filter_color, "", 
        product.name, variant.number, variant.description, "", "", product.retail_price, 
        "OLOOK", "nacional", "", "", product.filter_color, product.filter_color, 
        product.detail_by_token("material"), product.detail_by_token("material"), "", "", "", "", "", "", "", 
        product.detail_by_token('Detalhes'), "pendente", "pendente", "pendente", "pendente", "", "não", "", 
        product.description, "", "", ""]
    end
end