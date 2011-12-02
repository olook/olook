# -*- encoding : utf-8 -*-
module Abacos
  class Product
    extend ::Abacos::Helpers

    attr_reader :integration_protocol,
                :name, :description, :model_number, :category,
                :width, :height, :length, :weight,
                :color_name, :collection_id, :details, :profiles

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
        product = ::Product.find_or_create_by_model_number(self.model_number, 
                        :name         => self.name,
                        :category     => self.category,
                        :description  => self.description)

        integrate_attributes(product)
        integrate_details(product)
        integrate_profiles(product)

        Abacos::ProductAPI.confirm_product(self.integration_protocol)
      end
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
                                :display_on => DisplayDetailOn::DETAILS )
      end
    end

    def integrate_profiles(product)
      product.profiles.destroy_all
      self.profiles.each do |profile_name|
        profile = Profile.where("lower(name) = :profile_name", :profile_name => profile_name.downcase).first
        raise RuntimeError.new "Attemping to integrate invalid profile '#{profile_name}'" if profile.nil?
        product.profiles << profile
      end
    end

    def self.parse_abacos_data(abacos_product)
      { integration_protocol: abacos_product[:protocolo_produto],
        name:                 abacos_product[:nome_produto],
        description:          parse_description(abacos_product[:nome_produto], abacos_product[:descricao]),
        model_number:         abacos_product[:codigo_produto].to_s,
        category:             parse_category(abacos_product[:descricao_classe]),
        width:                abacos_product[:largura].to_f,
        height:               abacos_product[:espessura].to_f,
        length:               abacos_product[:comprimento].to_f,
        weight:               abacos_product[:peso].to_f,
        color_name:           parse_color( abacos_product[:descritor_pre_definido] ),
        collection_id:        parse_collection(abacos_product[:descricao_grupo]),
        details:              parse_details( abacos_product[:caracteristicas_complementares] ),
        profiles:             parse_profiles( abacos_product[:caracteristicas_complementares] ) }
    end
  private
    def self.parse_description(name, description)
      description.blank? ? name : description
    end

    def self.parse_color(data)
      find_in_descritor_pre_definido(data, 'COR')
    end
    
    def self.parse_details(data)
      items = parse_nested_data(data, :dados_caracteristicas_complementares)

      {}.tap do |result|
        items.each do |item|
          next if item[:tipo_nome].strip == 'Perfil'
          result[ item[:tipo_nome].strip ] = item[:texto].strip
        end
      end
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
      year ||= '2011'
      
      Date.civil(year.to_i, month, 1)
    rescue
      raise RuntimeError.new "Invalid collection '#{data}'"
    end
  end
end
