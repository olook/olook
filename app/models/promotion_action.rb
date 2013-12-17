# encoding: utf-8
class PromotionAction < ActiveRecord::Base
  validates :type, presence: true
  has_many :action_parameters

  @filters = {
    param: { desc: 'Parâmetro da Ação', kind: 'string' },
    full_price: {
      desc: 'Só descontar produtos com preço cheio (sem markdown)',
      kind: 'radio',
      options: {
        "Todos os produtos do site (full price + mark down)" => -1,
        "Apenas itens full price" => 1,
        "Apenas itens mark down" => 0,
        "Calcular o melhor desconto para o cliente (mark down ou esta) e aplicar" => 2
      },
      default: '2'
    },
    brand: {
      desc: 'Apenas itens da(s) marca(s)...',
      hint: 'Informe entre vírgulas Olook, Totem, etc',
      kind: 'string'
    },
    category: {
      desc: 'Apenas itens da(s) categoria(s)...',
      hint: 'Informe entre vírgulas sapato, bolsa, roupas...',
      kind: 'string'
    },
    subcategory: {
      desc: 'Apenas itens do(s) modelo(s)...',
      hint: 'Informe entre vírgulas anabela, camiseta, óculos de sol...',
      kind: 'string'
    },
    product_id: {
      desc: 'Apenas itens com o(s) ID(s)...',
      hint: 'Informe entre vírgulas 12770, 1703063091...',
      kind: 'string'
    },
    collection_theme: {
      desc: 'Apenas itens da(s) coleção(ões)...',
      hint: 'Informe entre vírgulas casual, trabalho...',
      kind: 'string'
    },
    complete_look_products: {
      desc: 'Descontar apenas itens do look completo',
      kind: 'boolean'
    }    
  }

  def self.filters
    @filters ||= PromotionAction.filters.dup
  end

  def self.default_filters
    @default_filters ||= Hash[PromotionAction.filters.dup.to_a.map { |k, h| [k, h[:default]] }]
  end

  def apply(cart, param, match)
    calculate(cart.items, param).each do |item|
      adjustment = item[:adjustment]
      item = cart.items.find(item[:id])
      item.cart_item_adjustment.update_attributes(value: adjustment, source: "#{match.class}: #{match.name}")
    end
  end

  def simulate(cart, param)
    cart.items.any? ? calculate(cart.items, param).map{|item| item[:adjustment]}.reduce(:+) : 0
  end

  def simulate_for_product(product_id, cart_items, param)
    if cart_items.any?
      _calc = calculate(cart_items, param)
      _c = _calc.find { |item| item[:product_id] == product_id }
      return _c ? _c[:adjustment] : 0
    end
    0
  end

  def desc_value(filters); end

  #
  # This method should return an Array of Hashes in the form:
  # => [{id: item.id, product_id: item.product.id, adjustment: item.price}]
  #
  def calculate(cart_items, param); end

  protected

  def filter_items(cart_items, filters)
    cis = cart_items.dup

    if filters['full_price'] == '1'
      cis.select! { |item| item.product.price == item.product.retail_price }
    elsif filters['full_price'] == '0'
      cis.select! { |item| item.product.price != item.product.retail_price }
    end

    if filters['product_id'].present?
      @product_id ||= Set.new(filters['product_id'].to_s.split(/[\n ]*,[\n ]*/).map { |w| w.to_s.strip.parameterize })
      cis.select! { |item| @product_id.include?(item.product.id.to_s) }
    elsif filters['subcategory'].present?
      @subcategory ||= Set.new(filters['subcategory'].to_s.split(/[\n ]*,[\n ]*/).map { |w| w.to_s.strip.parameterize })
      cis.select! { |item| @subcategory.include?(item.product.subcategory.to_s.strip.parameterize) }
    elsif filters['category'].present?
      @category = Set.new(filters['category'].to_s.split(/[\n ]*,[\n ]*/).map { |w| w.to_s.strip.parameterize })
      cis.select! { |item| @category.include?(item.product.category_humanize.to_s.strip.parameterize) }
    end

    if filters['brand'].present?
      @brands ||= Set.new(filters['brand'].to_s.split(/[\n ]*,[\n ]*/).map { |w| w.to_s.strip.parameterize })
      cis.select! { |item| @brands.include?(item.product.brand.to_s.strip.parameterize) }
    end

    if filters['collection_theme'].present?
      @collection_theme ||= Set.new(filters['collection_theme'].to_s.split(/[\n ]*,[\n ]*/).map { |w| w.to_s.strip.parameterize })
      cis.select! { |item| (@collection_theme & item.product.collection_themes.map { |c| c.name.to_s.strip.parameterize} ).size > 0 }
    end

    if filters['complete_look_products'] == '1'
      cis.select! { |item| item.cart.complete_look_product_ids_in_cart.include?(item.product.id) }
    end    

    cis
  end
end
