# -*- encoding : utf-8 -*-
module Parameters

  def params
    raise "Override this method!"
  end


  module ClassMethods

    PARAMETER_SUPPORTED_TYPES = [:decimal, :string, :integer]

    def parameter parameter_name, parameter_type

      define_method parameter_name.to_sym do
        value = params[parameter_name.to_sym][:value]
        type = parameter_type.to_sym
        
        raise "invalid parameter type" unless PARAMETER_SUPPORTED_TYPES.include? type

        type == :decimal ? BigDecimal.new(value) : value
      end

      define_method "#{parameter_name}=".to_sym do |value|
        params[parameter_name.to_sym][:value] = value.to_s
      end

    end
  end
end