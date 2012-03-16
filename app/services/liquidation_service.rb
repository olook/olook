class LiquidationService
  attr_accessor :denied_products_ids, :nonexisting_products_ids

  def self.active
    Liquidation.all.detect do |liquidation|
      Time.now >= liquidation.starts_at && Time.now <= liquidation.ends_at
    end
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

  def find_product product_id
    begin
      product = Product.find(product_id)
      #TODO: implement to see only visible products
      #product if product.is_visible
    rescue
      @nonexisting_products_ids << product_id
      nil
    end
  end

  def add_to_denied product_id
    @denied_products_ids << product_id
  end

  def update_resume
    @liquidation.resume = {
     :products_ids => products_ids,
     :categories => {
      1 => hasherize(subcategories_by_category_id(1)),
      2 => hasherize(subcategories_by_category_id(2)),
      3 => hasherize(subcategories_by_category_id(3))
     },
     :heels => hasherize(heels),
     :shoe_sizes => hasherize(shoe_sizes)
    }
    @liquidation.save
  end

  def update product_id, params
    LiquidationProduct.where(:product_id => product_id).update_all(
      :discount_percent => params[:discount_percent],
      :retail_price => params[:retail_price]
    )
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

  def collections_during_liquidation starts_at=@liquidation.starts_at, ends_at=@liquidation.ends_at
    collections = []
    Collection.all.each do |collection|
      collections << collection if consider_collection?(collection, starts_at, ends_at)
    end
    puts collections
    collections
  end

  def consider_collection? collection, starts_at, ends_at
    return false if (collection.start_date.to_datetime < starts_at) && (collection.end_date.to_datetime < starts_at)
    return false if (collection.start_date.to_datetime > ends_at) && (collection.end_date.to_datetime > ends_at)    
    (collection.start_date.to_datetime >= starts_at) || (collection.end_date.to_datetime <= ends_at)
  end

  private

  def products_ids
    @liquidation.liquidation_products.map(&:product_id).uniq
  end

  def heels
    @liquidation.liquidation_products.where(:category_id => 1).map(&:heel).uniq
  end

  def shoe_sizes
    @liquidation.liquidation_products.where(:category_id => 1).map(&:shoe_size).uniq
  end

  def subcategories_by_category_id category_id
    @liquidation.liquidation_products.where(:category_id => category_id).map(&:subcategory_name_label).uniq
  end

  def hasherize values
    values.compact!
    values.to_h values.map{|v| v.to_s.parameterize} if values
  end

end
