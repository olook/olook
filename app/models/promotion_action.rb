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
    cart.items.any? ? (calculate(cart.items, param).map{|item| item[:adjustment]}.reduce(:+) || 0) : 0
  end

  def simulate_for_value(value, param)
    calculate_value(value, param)
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

  def filter_items(cart_items, filters)
    cis = cart_items.dup

    filters.keys.each do |fn|
      next if filters[fn].blank?
      send("apply_filter_#{fn}", cis, filters) rescue NoMethodError
    end

    cis
  end

  private

  def apply_filter_full_price(cis, filters)
    if filters['full_price'] == '1'
      cis.select! { |item| item.product.price == item.product.retail_price }
    elsif filters['full_price'] == '0'
      cis.select! { |item| item.product.price != item.product.retail_price }
    end
  end

  def apply_filter_product_id(cis, filters)
    filter_by(cis, filters, 'product_id') do |item|
      item.product_id
    end
  end

  def apply_filter_subcategory(cis, filters)
    filter_by(cis, filters, 'subcategory') do |item|
      item.product.subcategory
    end
  end

  def apply_filter_category(cis, filters)
    filter_by(cis, filters, 'category') do |item|
      item.product.category_humanize
    end
  end

  def apply_filter_brand(cis, filters)
    filter_by(cis, filters, 'brand') do |item|
      item.product.brand
    end
  end

  def apply_filter_collection_theme(cis, filters)
    filter_by(cis, filters, 'collection_theme', condition: lambda { |collection_theme, item|
      (collection_theme & item.product.collection_themes.map { |c| c.slug.to_s.strip.parameterize} ).size > 0
    })
  end

  def apply_filter_complete_look_products(cis, filters)
    if filters['complete_look_products'] == '1'
      cis.select! { |item| item.cart.complete_look_product_ids_in_cart.include?(item.product_id) }
    end
  end

  def filter_by(cis, filters, filter_name, opts={})
    
    formatted_filters = filters[filter_name].to_s.split(/[\n ]*,[\n ]*/)
    formatted_filters.map! { |w| w.to_s.strip.parameterize }
    formatted_filters = Set.new(formatted_filters)

    if opts[:condition] && opts[:condition].respond_to?(:call)
      cis.select! { |item| opts[:condition].call(formatted_filters, item) }
    else
      cis.select! { |item| formatted_filters.include?(yield(item).to_s.strip.parameterize) }
    end
  end
end

