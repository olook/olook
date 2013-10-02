class LiquidationService
  attr_accessor :denied_products_ids, :nonexisting_products_ids
  @@active = nil
  @@active_expire = nil

  def self.active
    return @@active if Rails.application.config.cache_classes && !Rails.env.test? && @@active && @@active_expire > Time.zone.now
    @@active = Liquidation.where('? BETWEEN liquidations.starts_at AND liquidations.ends_at', Time.zone.now).first
    @@active_expire = 5.minutes.from_now
    @@active
  end

  def initialize liquidation_id
    @liquidation = Liquidation.find(liquidation_id)
    @denied_products_ids, @nonexisting_products_ids = [], []
  end

  def add products_ids, discount_percent
    products_ids.split(",").each do |product_id|
      if product = find_product(product_id)
        lps = LiquidationProductService.new(
          @liquidation,
          product,
          discount_percent,
          collections_during_liquidation
        )
        add_to_denied(product.id) unless lps.save
      end
    end
    update_resume
  end
  
  def update_resume
    @liquidation.resume = {
     :products_ids => products_ids,
     :categories => {
      1 => hasherize(subcategories_by_category_id(1)),
      2 => hasherize(subcategories_by_category_id(2)),
      3 => hasherize(subcategories_by_category_id(3))
     },
     :heels => hasherize(sorted_heels,false),
     :shoe_sizes => hasherize(shoe_sizes)
    }
    @liquidation.save
  end
  
  def conflicts_existing_products? starts_at=@liquidation.starts_at, ends_at=@liquidation.ends_at
    result = false
    @liquidation.liquidation_products.each do |product|
      if LiquidationProductService.new(@liquidation,
       Product.find(product.product_id),
       nil,
       collections_during_liquidation(starts_at, ends_at)).conflicts_collections?
        result = true
        break
      end
    end
    result
  end
  
  def update product_id, params
    LiquidationProduct.where(:product_id => product_id).update_all(
      :discount_percent => params[:discount_percent],
      :retail_price => params[:retail_price]
    )
  end

  private

  def find_product product_id
    begin
      product = Product.find(product_id)
    rescue
      @nonexisting_products_ids << product_id
      nil
    end
  end

  def add_to_denied product_id
    @denied_products_ids << product_id
  end

  def collections_during_liquidation starts_at=@liquidation.starts_at, ends_at=@liquidation.ends_at
    collections = []
    Collection.all.each do |collection|
      collections << collection if consider_collection?(collection, starts_at, ends_at)
    end
    collections
  end

  def consider_collection? collection, starts_at, ends_at
    return false if (collection.start_date.to_datetime < starts_at) && (collection.end_date.to_datetime < starts_at)
    return false if (collection.start_date.to_datetime > ends_at) && (collection.end_date.to_datetime > ends_at)    
    (collection.start_date.to_datetime >= starts_at) || (collection.end_date.to_datetime <= ends_at)
  end

  def products_ids
    @liquidation.liquidation_products.map(&:product_id).uniq
  end

  def heels
    @liquidation.liquidation_products.where(:category_id => Category::SHOE).map(&:heel_label).uniq
  end

  def shoe_sizes
    @liquidation.liquidation_products.where(:category_id => Category::SHOE).map(&:shoe_size).uniq
  end

  def subcategories_by_category_id category_id
    @liquidation.liquidation_products.where("category_id = ? and inventory > 0", category_id).map(&:subcategory_name_label).uniq
  end

  def hasherize values, sort_values=true
    if sort_values
      values.compact!
      values = values.sort if sort_values    
    end
    values.to_h values.map{|v| v.to_s.parameterize} if values
  end
  
  def sorted_heels
    if heels 
      heels.compact!
      heels.delete("")
      heels.map{|h| {:label => h, :float => (h.split[0].gsub(",", ".") rescue 0)}}.sort_by{|x| x[:float].to_f}.map{|x| x[:label]}
    end
  end

end
