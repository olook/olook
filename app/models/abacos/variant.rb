# -*- encoding : utf-8 -*-
module Abacos
  class Variant

    M_OFFICER_TABLE_SIZE = {"1" => "P", "2" => "M", "3" => "G"}

    extend ::Abacos::Helpers

    attr_reader :integration_protocol,
                :model_number, :number, :description, :display_reference

    def initialize(parsed_data)
      parsed_data.each do |key, value|
        self.instance_variable_set "@#{key}", value
      end
    end

    def attributes
      { number:             self.number,
        description:        self.description,
        display_reference:  self.display_reference,
        is_master:          "false" }
    end

    def father_attributes
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
        :brand          => self.brand,
        :barcode        => self.barcode,
        :fiscal_classification => self.fiscal_classification,
        :product_origin => self.product_origin
      }
    end

    def integrate
      product = ::Product.find_by_model_number(self.model_number)
      raise RuntimeError.new "O produto pai [#{self.model_number}] não foi encontrado, e com isso a variante #{self.number} nao pode ser integrada" if product.nil?

      variant = product.variants.find_by_number(self.number) || product.variants.build
      variant.copy_from_master_variant! if variant.new_record?
      variant.update_attributes(self.attributes)
      father_attributes.each do |k, v|
        product[k] = v if product[k].blank?
      end
      product.save!
      variant.save!

      confirm_variant
    end

    def self.parse_abacos_data(abacos_product)
      parsed_description = parse_description( abacos_product[:descritor_pre_definido] )
      parsed_category = parse_category(abacos_product[:descricao_classe])

      { integration_protocol: abacos_product[:protocolo_produto],
        model_number:         abacos_product[:codigo_produto_pai],
        number:               abacos_product[:codigo_produto],
        description:          parsed_description,
        display_reference:    parse_display_reference(parsed_description, parsed_category) }
    end

    def confirm_variant
      Resque.enqueue(Abacos::ConfirmProduct, self.integration_protocol, self.number)
    end

  private
    def self.parse_description(abacos_descritor_pre_definido)
      size = find_in_descritor_pre_definido(abacos_descritor_pre_definido, 'TAMANHO')
      sanitize_product_size(size)
    end

    def self.parse_display_reference(description, category)
      [Category::SHOE, Category::CLOTH].include?(category) ? "size-#{description}" : 'single-size'
    end


    def self.sanitize_product_size size
      return 'Único' if size.blank?

      if M_OFFICER_TABLE_SIZE.keys.include?(size)
        M_OFFICER_TABLE_SIZE[size]
      else
        size
      end
    end

  end

end
