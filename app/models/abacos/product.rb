# -*- encoding : utf-8 -*-
module Abacos
  class Product
    extend ::Abacos::Helpers

    attr_reader :integration_protocol,
                :name, :description, :model_number, :category,
                :width, :height, :length, :weight,
                :color_name, :collection_id, :how_to, :details, :profiles

    def initialize(parsed_data)
      parsed_data.each do |key, value|
        self.instance_variable_set "@#{key}", value
      end
    end

    def attributes
      { name:         self.name,
        description:  self.description,
        category:     self.category,
        model_number: self.model_number,
        color_name:   self.color_name,
        width:        self.width,
        height:       self.height,
        length:       self.length,
        weight:       self.weight }
    end
    
    def integrate
      ::Product.transaction do
        product = find_or_initialize_product
        integrate_attributes(product)
        integrate_details(product)
        integrate_profiles(product)
        confirm_product
      end
    end
    
    def find_or_initialize_product
      product = ::Product.find_by_model_number(self.model_number)
      if product.nil?
        product = ::Product.new(:model_number => self.model_number,
                                :name         => self.name,
                                :category     => self.category,
                                :description  => self.description,
                                :is_visible   => false)
        product.id = self.model_number.to_i
        product.save!
      end
      product
    end

    def integrate_attributes(product)
      product.update_attributes(self.attributes)
      product.collection = Collection.find(self.collection_id) unless self.collection_id.nil?
      product.save!
    end

    def integrate_details(product)
      product.details.destroy_all
      self.details.each do |key, value|
        product.details.create( :translation_token => key,
                                :description => value,
                                :display_on => DisplayDetailOn::SPECIFICATION )
      end

      integrate_how_to(product)
    end
    
    def integrate_how_to(product)
      product.details.create( :translation_token => 'Como vestir',
                              :description => self.how_to,
                              :display_on => DisplayDetailOn::HOW_TO )
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
      Resque.enqueue(Abacos::ConfirmProduct, self.integration_protocol)
    end

    def self.parse_abacos_data(abacos_product)
      { integration_protocol: abacos_product[:protocolo_produto],
        name:                 parse_name(abacos_product[:descricao], abacos_product[:nome_produto]),
        description:          parse_description(abacos_product[:caracteristicas_complementares], abacos_product[:nome_produto]),
        model_number:         abacos_product[:codigo_produto].to_s,
        category:             parse_category(abacos_product[:descricao_classe]),
        width:                abacos_product[:largura].to_f,
        height:               abacos_product[:espessura].to_f,
        length:               abacos_product[:comprimento].to_f,
        weight:               abacos_product[:peso].to_f,
        color_name:           parse_color( abacos_product[:descritor_pre_definido] ),
        collection_id:        parse_collection(abacos_product[:descricao_grupo]),
        details:              parse_details( abacos_product[:caracteristicas_complementares] ),
        how_to:               parse_how_to( abacos_product[:caracteristicas_complementares] ),
        profiles:             parse_profiles( abacos_product[:caracteristicas_complementares] ) }
    end
  private
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

    def self.parse_name(name, fallback)
      name.blank? ? fallback : name
    end

    def self.parse_color(data)
      find_in_descritor_pre_definido(data, 'COR')
    end
    
    def self.parse_details(data)
      items_to_skip = ['Perfil', 'Como vestir', 'Descrição']
      items = parse_nested_data(data, :dados_caracteristicas_complementares)

      {}.tap do |result|
        items.each do |item|
          next if items_to_skip.include?(item[:tipo_nome].strip)
          result[ item[:tipo_nome].strip ] = item[:texto].strip
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
    
    def self.parse_collection_date(data)
      month_names = I18n.t('date.month_names').compact.map(&:downcase)
      filter = eval("/#{month_names.join('|')}|\\d{4}/")

      pieces = data.strip.downcase.split(/\s|\//)
      pieces = pieces.delete_if {|piece| !piece.match(filter) }
      
      month_name, year = pieces

      month = month_names.index(month_name)+1
      year ||= '2011'
      
      Date.civil(year.to_i, month, 1)
    rescue
      raise RuntimeError.new "Invalid collection '#{data}'"
    end
  end
end
