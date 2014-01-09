class SociomanticScore

  def self.calculate_for product
    score = (0.3 * grade_score_for(product) + 0.7 * inventory_score_for(product)) * 9
    score.round(2)    
  end

  private 
    def self.grade_score_for product
      grade = product.variants.size
      grade_with_inventory = product.variants.select{|v| v.inventory > 0}.count
      grade_score = grade_with_inventory.to_f / grade.to_f      
    end

    def self.inventory_score_for product
      inventory = product.inventory
    
      inventory_score = if inventory == 0 
        0
      elsif inventory > 0 && inventory < 30
        (inventory / 10 + 1) * 0.25
      else
        1
      end

      inventory_score.to_f
    end
end