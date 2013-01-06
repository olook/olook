# -*- encoding : utf-8 -*-
module Parameters

  attr_accessor :params

  def self.included(base)
    base.extend(ClassMethods)
  end

  def convert_to value, type 

    if type == :decimal
      converted_value = BigDecimal.new(value) 
    elsif type == :integer
      converted_value = value.to_i
    else
      converted_value = value
    end

    converted_value
  end

  #
  # The idea behind this module is to provide a simple way to serialize / deserialize
  # field values (parameter) to store it in a database. To use it, include this module 
  # and declare your parameters:
  # 
  # parameter :field_name, :field_type.
  #
  # For instance only :decimal, :integer and :string are supported. And the default is
  # :string
  #
  module ClassMethods

    PARAMETER_SUPPORTED_TYPES = [:decimal, :string, :integer]

    def parameter parameter_name, parameter_type

      name, type = validate_parameter_name_and_type parameter_name, parameter_type

      define_method name do
        value = params[name][:value]
        convert_to value, type
      end

      define_method "#{parameter_name}=".to_sym do |value|
        params[name][:value] = value.to_s
        params[name][:type] = type
      end

    end


    private

      def validate_parameter_name_and_type parameter_name, parameter_type
        type = parameter_type.to_sym
        raise "invalid parameter type" unless PARAMETER_SUPPORTED_TYPES.include? type
        parameter = parameter_name.to_sym
        [parameter, type]
      end

  end
end