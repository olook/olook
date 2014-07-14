# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :detail do
    association :product, :factory => [:shoe, :casual]


    factory :tip do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token "Dica"
      description "Loren ipsun"
    end
    factory :keywords do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token "Keywords"
      description "Loren ipsun"
    end
    factory :supplier_color_detail do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token "Cor fornecedor"
      description "Blue"
    end
    factory :product_color_detail do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token "Cor produto"
      description "Dark Blue"

    end
    factory :filter_color_detail do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token "Cor filtro"
      description "Blue"
    end

    factory :heel_detail do
      display_on DisplayDetailOn::SPECIFICATION
      description "High heel"
      translation_token 'heel'
    end

    factory :invisible_detail do
      display_on DisplayDetailOn::INVISIBLE
      description "Meta data used for data mining"
      translation_token 'meta_data'
    end
    factory :how_to_detail do
      display_on DisplayDetailOn::HOW_TO
      description "How to wear"
      translation_token 'how to'
    end

    factory :shoe_subcategory_name do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Categoria'
      description "Sandalia"
    end

    factory :shoe_heel do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Salto'
      description "0,5 cm"
    end

    factory :shoe_with_metal do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Metal'
      description "Ouro light"
    end

    factory :shoe_with_leather do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Material externo'
      description "Couro"
    end

    factory :sandalia do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Categoria'
      description "Sandalia"
    end    

    factory :scarpin do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Categoria'
      description "Scarpin"
    end

  end

  factory :bag_detail, :class => Detail do
    association :product, :factory => :basic_bag
    factory :bag_subcategory_name do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Categoria'
      description "Bolsa Azul"
    end
  end

  factory :accessory_detail, :class => Detail do
    association :product, :factory => :basic_accessory
    factory :accessory_subcategory_name do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Categoria'
      description "Colar"
    end
  end

  factory :garment_detail, :class => Detail do
    association :product, :factory => :simple_garment
    factory :garment_subcategory_name do
      display_on DisplayDetailOn::SPECIFICATION
      translation_token 'Categoria'
      description "Camiseta Amarela"
    end
  end

end
