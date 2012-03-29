# this class is responsible for updating the liquidation products fields based on the source
# the fields that are being updated are subcategory and heel

class LiquidationFetchService  
  def initialize liquidation
    @liquidation = liquidation
    @products = Product.find(@liquidation.resume[:products_ids])
  end
  
  def fetch!
    @products.each do |product|
      @product = product
      process
    end
    LiquidationService.new(@liquidation).update_resume
  end
  
  def process 
    @lps = LiquidationProductService.new(@liquidation, @product)
    update_subcategory
    update_heel
  end
  
  def update_subcategory
    update({:subcategory_name => @lps.subcategory_name.try(:parameterize), :subcategory_name_label => @lps.subcategory_name})
  end
  
  def update_heel
    update({:heel => @lps.heel.try(:parameterize), :heel_label => @lps.heel})
  end
  
  def update params
    LiquidationProduct.where(:product_id => @product.id).update_all(params)
  end
  
end