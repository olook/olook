# -*- encoding : utf-8 -*-
module Abacos
  class Product
    extend ::Abacos::Helpers

    PRODUCT_COLOR_FIELDS = ["Cor fornecedor", "Cor produto", "Cor filtro"]

    attr_reader :integration_protocol,
                :name, :description, :model_number, :category,
                :width, :height, :length, :weight, :color_category,
                :color_name, :collection_id, :how_to, :collection_themes, :details, :profiles,
                :is_kit, :pre_defined_descriptor, :class_description, :brand, :producer_code

    def initialize(parsed_data)
      parsed_data.each do |key, value|
        self.instance_variable_set "@#{key}", value
      end
    end

    def attributes
      {
        :name           => self.name,
        :description    => self.description,
        :category       => self.category,
        :model_number   => self.model_number,
        :color_name     => self.color_name,
        :width          => self.width,
        :height         => self.height,
        :length         => self.length,
        :weight         => self.weight,
        :is_kit         => self.is_kit,
        :producer_code  => self.producer_code,
        :brand          => self.brand
      }
    end

    def integrate
      ::Product.transaction do
        product = find_or_initialize_product
        integrate_attributes(product)
        integrate_details(product)
        integrate_profiles(product)
        integrate_catalogs(product)
        if product.is_kit
          create_kit_variant
        else
          confirm_product
        end
      end
    end

    def find_or_initialize_product
      product = ::Product.find_by_model_number(self.model_number)
      if product.nil?
        product = ::Product.new(
          :model_number => self.model_number,
          :name         => self.name,
          :category     => self.category,
          :description  => self.description,
          :is_visible   => false,
          :is_kit       => self.is_kit,
          :brand        => self.brand
        )
        product.id = self.model_number.to_i
        product.save!
      end
      product
    end

    def integrate_catalogs(product)
      collection_themes_in_catalog = self.collection_themes.each.map do |item|
        begin
          CollectionTheme.find_by_id!(item.to_i)
        rescue ActiveRecord::RecordNotFound => e
          #todo: tratar
        end
      end
      CatalogService.save_product product, :collection_themes => collection_themes_in_catalog.compact
    end

    def integrate_attributes(product)
      product.update_attributes(self.attributes)
      product.collection = Collection.find(self.collection_id) unless self.collection_id.nil?
      product.save!
    end

    def integrate_details(product)
      product.details.destroy_all
      self.details.each do |key, value|
        product.details.create(
          :translation_token => key,
          :description => value,
          :display_on => DisplayDetailOn::SPECIFICATION
        )
      end

      integrate_how_to(product)
    end

    def integrate_how_to(product)
      product.details.create(
        :translation_token => 'Como vestir',
        :description => self.how_to,
        :display_on => DisplayDetailOn::HOW_TO
      )
    end

    def integrate_profiles(product)
      product.profiles.destroy_all
      self.profiles.each do |profile_name|
        profile = Profile.where("lower(name) = :profile_name", :profile_name => profile_name.downcase).first
        raise RuntimeError.new "Attemping to integrate invalid profile '#{profile_name}'" if profile.nil?
        product.profiles << profile
      end
    end

    def confirm_product
      Resque.enqueue(Abacos::ConfirmProduct, self.integration_protocol, self.model_number)
    end

    def create_kit_variant
      parsed_data = create_abacos_kit_variant_data
      Resque.enqueue(Abacos::Integrate, Abacos::Variant.to_s, parsed_data)
    end

    def create_abacos_kit_variant_data
      Abacos::Variant.parse_abacos_data({
        :descritor_pre_definido   => keys_to_symbol(self.pre_defined_descriptor),
        :descricao_classe         => keys_to_symbol(self.class_description),
        :protocolo_produto        => self.integration_protocol,
        :codigo_produto_pai       => self.model_number,
        :codigo_produto       => self.model_number
        })
    end

    def self.parse_abacos_data(abacos_product)
      {
        :integration_protocol   => abacos_product[:protocolo_produto],
        :name                   => parse_name(abacos_product[:descricao], abacos_product[:nome_produto]),
        :description            => parse_description(abacos_product[:caracteristicas_complementares], abacos_product[:nome_produto]),
        :model_number           => abacos_product[:codigo_produto].to_s,
        :category               => parse_category(abacos_product[:descricao_classe]),
        :width                  => abacos_product[:largura].to_f,
        :height                 => abacos_product[:espessura].to_f,
        :length                 => abacos_product[:comprimento].to_f,
        :weight                 => abacos_product[:peso].to_f,
        :producer_code          => parse_producer_code(abacos_product[:codigo_fabricante]),
        :color_name             => parse_color( abacos_product[:descritor_pre_definido] ),
        :collection_id          => parse_collection(abacos_product[:descricao_grupo]),
        :details                => parse_details( abacos_product[:caracteristicas_complementares], abacos_product[:descritor_simples] ),
        :how_to                 => parse_how_to( abacos_product[:caracteristicas_complementares] ),
        :collection_themes      => parse_collection_themes( abacos_product[:categorias_do_site][:rows][:dados_categorias_do_site]),
        :profiles               => parse_profiles( abacos_product[:caracteristicas_complementares] ),
        :is_kit                 => abacos_product[:produto_kit].present? ? abacos_product[:produto_kit] : false,
        :pre_defined_descriptor => abacos_product[:descritor_pre_definido],
        :class_description      => abacos_product[:descricao_classe],
        :brand                  => parse_brand( abacos_product[:descritor_pre_definido] )
      }
    end
  private

    def self.parse_collection_themes(collection_themes)
      collection_themes_array = if collection_themes.kind_of?(Array)
        collection_themes.each.map { |item|
          item.fetch(:codigo_categoria)
        }
      else
        [collection_themes.fetch(:codigo_categoria)]
      end
      collection_themes_array.compact
    end

    # def self.parse_color_category(categories)
    #   categories_array = if categories.kind_of?(Array)
    #     categories.each.map { |item|
    #       item.fetch(:codigo_categoria) if item[:codigo_categoria_pai] != 0
    #     }
    #   else
    #     [categories.fetch(:codigo_categoria)] if item[:codigo_categoria_pai] != 0
    #   end
    #   categories_array.compact
    # end

    def self.parse_description(data, fallback_description)
      items = parse_nested_data(data, :dados_caracteristicas_complementares)

      result = fallback_description
      items.each do |item|
        if item[:tipo_nome].strip == 'Descrição'
          result = item[:texto].strip
          break
        end
      end
      result
    end

    def self.parse_producer_code(data)
      data.split("/").first
    end

    def self.parse_name(name, fallback)
      name.blank? ? fallback : name
    end

    def self.parse_color(data)
      find_in_descritor_pre_definido(data, 'COR')
    end

    def self.parse_brand(data)
      find_in_descritor_pre_definido(data, 'MARCA')
    end

    def self.parse_details(data, data_simple_descriptor)
      items_to_skip = ['Perfil', 'Como vestir', 'Descrição']
      items = parse_nested_data(data, :dados_caracteristicas_complementares)
      descritor_simples = parse_nested_data(data_simple_descriptor, :dados_descritor_simples)

      {}.tap do |result|
        items.each do |item|
          next if items_to_skip.include?(item[:tipo_nome].strip)
          next if item[:texto].strip.downcase == 'default'
          result[ item[:tipo_nome].strip ] = item[:texto].strip
        end

        descritor_simples.each do |descritor|
          index = descritor[:numero].to_i - 1
          result[PRODUCT_COLOR_FIELDS[index]] = descritor[:descricao]
        end
      end
    end

    def self.parse_how_to(data)
      items = parse_nested_data(data, :dados_caracteristicas_complementares)

      result = ''
      items.each do |item|
        if item[:tipo_nome].strip == 'Como vestir'
          result = item[:texto].strip
          break
        end
      end
      result
    end

    def self.parse_profiles(data)
      items = parse_nested_data(data, :dados_caracteristicas_complementares)

      result = []
      items.each do |item|
        if item[:tipo_nome].strip == 'Perfil'
          result += item[:texto].split(',')
        end
      end
      result.map &:strip
    end

    def self.parse_collection(data)
      return nil if data.blank?
      reference_date = parse_collection_date(data)
      Collection.for_date(reference_date).try :id
    end

    def self.parse_collection_date(data)
      month_names = I18n.t('date.month_names').compact.map(&:downcase)
      filter = eval("/#{month_names.join('|')}|\\d{4}/")

      pieces = data.strip.downcase.split(/\s|\//)
      pieces = pieces.delete_if {|piece| !piece.match(filter) }

      month_name, year = pieces
      month = month_names.index(month_name)+1

      Date.civil(year.to_i, month, 1)
    rescue
      raise RuntimeError.new "Invalid collection '#{data}'"
    end

    def keys_to_symbol(params)
      case params.class.to_s
        when "Hash"
          Hash[params.map { |k,v| [k.to_sym, keys_to_symbol(v)] } ]
        when "Array"
          params.map { |v| keys_to_symbol(v) }
        else
          params
      end
    end

  end
end
