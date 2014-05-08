module Search
  module Searchable
    def self.included(base)
      base.extend(ClassMethods)
    end

    attr_accessor :id

    def initialize id, data
      self.id = id
      @fields = {}
      data.each do |key, val|
        self.send("#{key}=", val) rescue NoMethodError
      end
    end

    def format_for_type(kind, val, options={})
      if /array/ !~ kind
        _val = val[0]
      end

      case kind
      when :uint
        _val = _val.to_i
      when :boolean
        _val.to_s == "1"
      when :decimal
        _val = normalize_decimal_numbers(_val, options[:scale])
      else
        _val = _val
      end
      _val
    end

    def [](key)
      @fields[key.to_s]
    end

    def []=(key, val)
      @fields[key.to_s] = val
    end

    private

    def normalize_decimal_numbers(val, scale)
      BigDecimal.new(val.to_d/scale.to_d)
    end

    module ClassMethods
      def field(name, kind=:text, options={})
        @@fields ||= {}
        @@kinds ||= {}
        @@fields[name] ||= []
        @@kinds[kind] ||= []
        @@fields[name] << kind
        @@kinds[kind] << name
        add_field(name, kind, options)
      end

      def add_field(name, kind, options={})
        define_method("#{name}=") do |val|
          @fields[name] = format_for_type(kind, val, options)
        end

        define_method("#{name}") do
          @fields[name]
        end
      end
    end
  end
end
