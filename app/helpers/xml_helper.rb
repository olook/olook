# -*- encoding : utf-8 -*-
module XmlHelper

  def build_installment_text(price)
    installments_number = CreditCard.installments_number_for(price)
    installment_value = price / installments_number
    "#{installments_number} x #{number_with_precision(installment_value, :precision => 2)}"
  end

  def full_category(product)
    category = Category.t(product.category)
    product.subcategory.present? ? "#{category} - #{product.subcategory}" : category
  end

  def to_ilove_category(category)
  	ilove_categories[category]
  end

  private
  	def ilove_categories
  		@ilove_categories ||= { Category::SHOE       => 12,
							    Category::BAG        => 18,
							    Category::ACCESSORY  => 17 }
  	end
end