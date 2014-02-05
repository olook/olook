# -*- encoding : utf-8 -*-
module GoogleAnalyticsHelper
  def google_ids products=nil
    case
    when products.kind_of?(Product)
      products.id.to_s
    when products.kind_of?(Cart)
      products.items.map{|item| item.variant_id.to_s}
    when products.kind_of?(Order)
      products.line_items.map(&:variant_id)
    else
      ''
    end
  end


  def google_name products=nil
    case
    when products.kind_of?(Product)
      products.name
    when products.kind_of?(Cart)
      products.items.map(&:name).to_s.gsub(/"/, "'")
    when products.kind_of?(Order)
      products.line_items.map{|v|v.variant.name}.to_s.gsub(/"/, "")
    end
  end

  def google_value products=nil
    case
    when products.kind_of?(Product)
      products.retail_price.to_s.to_s.gsub(/"/, "'")
    when products.kind_of?(Cart)
      products.items.sum(&:retail_price).to_s.gsub(/"/, "'")
    when products.kind_of?(Order)
      products.line_items.sum(&:retail_price).to_s.gsub(/"/, "'")
    end
  end

end
