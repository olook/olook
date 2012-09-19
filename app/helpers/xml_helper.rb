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

	def get_ilove_category_for product
		subcategory_in_downcase = product.subcategory_name.nil? ? nil : product.subcategory_name.downcase
		ilove_categories[product.category][subcategory_in_downcase]
	end

	def to_google_shopping_category(category)
		google_shopping_categories[category]
	end


	## We send ALWAYS the image at Position 1 to our partners
	def first_image_of product
		image_at_position(product, DisplayPictureOn::GALLERY_1)
	end

	def image_at_position(product, position)
		product.picture_at_position(position).try(:image)
	end

	private
		def ilove_categories()

			shoe_subcategories = {
		  		'sandália' => 14,
		  		'bota' => 13
		  	}
		  	shoe_subcategories.default=12

		  	bag_subcategories={}
		  	bag_subcategories.default=18

		  	accessory_subcategories={}
		  	accessory_subcategories.default=17

			@ilove_categories ||= { 
		  		Category::SHOE       => shoe_subcategories,
		  		Category::BAG        => bag_subcategories,
		  		Category::ACCESSORY  => accessory_subcategories
			}
		end

		def google_shopping_categories()
			@google_shopping_categories ||= { 	
				Category::SHOE => 'Vestuário e acessórios > Sapatos',
				Category::BAG => 'Vestuário e acessórios > Bolsas',
				Category::ACCESSORY => 'Vestuário e acessórios > Acessórios'
			}
		end
end