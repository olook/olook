# -*- encoding : utf-8 -*-
module XmlHelper

  def discount_sanitize(product)
   (100-(product.retail_price*100/product.price)).to_s.to_i
  end

  def full_image_path path
    "http:#{path}" unless path.blank?
  end

  def build_installment_text(price, options = {})
    "#{installments_number(price)} x #{installments_value(price, options)}"
  end

  def installments_number(price)
    CreditCard.installments_number_for(price)
  end

  def installments_value(price, options = {})
    options[:separator] ||= '.'
    number_with_precision(price / installments_number(price), precision: 2, separator: options[:separator])
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

  def calculate_discount_for product
    (100-((product.retail_price / product.price)*100)).ceil
  end

  private
    def ilove_categories

      shoe_subcategories = {
        'sandália' => 14,
        'bota' => 13
      }
      shoe_subcategories.default=12

      bag_subcategories={}
      bag_subcategories.default=18

      accessory_subcategories={}
      accessory_subcategories.default=17

      choth_subcategories={
        'saia' => 9,
        'shorts' => 9,
        'calça' => 8,
        'vestido' => 5,
        'casaco' => 7,
        'jaqueta' => 7,
        'blusa' => 6
      }

      choth_subcategories.default=4

      @ilove_categories ||= {
        Category::SHOE       => shoe_subcategories,
        Category::BAG        => bag_subcategories,
        Category::ACCESSORY  => accessory_subcategories,
        Category::CLOTH  => choth_subcategories,
        Category::LINGERIE  => choth_subcategories,
        Category::BEACHWEAR => choth_subcategories
      }
    end

    def google_shopping_categories()
      @google_shopping_categories ||= {
        Category::SHOE => 'Vestuário e acessórios > Sapatos',
        Category::BAG => 'Vestuário e acessórios > Bolsas',
        Category::ACCESSORY => 'Vestuário e acessórios > Acessórios',
        Category::CLOTH => 'Vestuário e acessórios > Roupas',
        Category::LINGERIE  => 'Vestuário e acessórios > Roupas',
        Category::BEACHWEAR => 'Vestuário e acessórios > Roupas'
      }
    end
end
