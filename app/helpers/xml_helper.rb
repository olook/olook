# -*- encoding : utf-8 -*-
module XmlHelper

  def discount_sanitize(product)
   (100-(product.retail_price*100/product.price)).to_s.to_i
  end

  def full_image_path path
    if path && !(path.to_s =~ /http/)
      "http:#{path}"
    else
      path
    end
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
    subcategory_in_downcase = product.subcategory_name.nil? ? nil : product.subcategory_name.parameterize
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
        'sandalia' => 14,
        'bota' => 13,
        'flats' => 164,
        'tenis' => 15,
      }
      shoe_subcategories.default=12

      bag_subcategories={}
      bag_subcategories.default=18

      accessory_subcategories={
        'anel' => 82,
        'pulseiras' => 60,
        'colar' => 80,
        'brinco' => 81,
        'cachecol' => 123,
        'chapeu' => 122,
        'cinto' => 121,
        'relogio' => 124
      }
      accessory_subcategories.default=17

      cloth_subcategories = {
        'saia' => 9,
        'saias-midi' => 102,
        'saias-mini' => 101,
        'saias-longas' => 103,
        'shorts' => 104,
        'vestido' => 5,
        'vestidos-curto' => 86,
        'vestidos-longos' => 85,
        'vestidos-de-festa' => 87,
        'blusa' => 6,
        'regatas' => 88,
        'camisas' => 89,
        't-shirts' => 90,
        'tops' => 91,
        'casaco' => 7,
        'blazer' => 92,
        'cardiga' => 93,
        'jaquetas' => 94,
        'coletes' => 95,
        'calça' => 8,
        'cropped' => 96,
        'flare' => 97,
        'jeans' => 98,
        'legging' => 99,
        'skinny' => 100
      }

      cloth_subcategories.default = 4

      lingerie_subcategories = {
        'basica'=>107,
        'sutia'=>105,
        'calcinha'=>106,
        'renda'=>108
      }

      lingerie_subcategories.default = 10

      beachwear_subcategories = {
        'biquini' => 109,
        'maio' => 110,
        'workout' => 111,
        'saida-de-praia' => 112
      }
      beachwear_subcategories.default = 11

      @ilove_categories ||= {
        Category::SHOE       => shoe_subcategories,
        Category::BAG        => bag_subcategories,
        Category::ACCESSORY  => accessory_subcategories,
        Category::CLOTH  => cloth_subcategories,
        Category::LINGERIE  => cloth_subcategories,
        Category::BEACHWEAR => beachwear_subcategories,
        Category::CURVES => cloth_subcategories
      }
    end

    def google_shopping_categories()
      @google_shopping_categories ||= {
        Category::SHOE => 'Vestuário e acessórios > Sapatos',
        Category::BAG => 'Vestuário e acessórios > Bolsas',
        Category::ACCESSORY => 'Vestuário e acessórios > Acessórios',
        Category::CLOTH => 'Vestuário e acessórios > Roupas',
        Category::LINGERIE  => 'Vestuário e acessórios > Roupas',
        Category::BEACHWEAR => 'Vestuário e acessórios > Roupas',
        Category::CURVES => 'Vestuário e acessórios > Roupas'
      }
    end
end
