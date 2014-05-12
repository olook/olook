module Search
  module Searchable
    def self.included(base)
      base.extend(ClassMethods)
    end

    attr_accessor :id

    def initialize id, data
      self.id = id
      @fields = {}
      self.class.fields.each do |name, kind|
        @fields[name.to_s] = kind.clone
      end
      data.each do |key, val|
        self[key] = val
      end
    end

    def [](key)
      @fields[key.to_s].value if @fields[key.to_s]
    end

    def []=(key, val)
      ( @fields[key.to_s] || Field.new(key) ).value = val
    end

    private

    module ClassMethods
      def add_field(name, kind=:text, options={})
        name = name.to_s
        @@fields ||= {}
        @@fields[name] = Field.factory(kind, name, options)
        define_field_methods(name, kind, options)
      end

      def field(name)
        @@fields[name.to_s]
      end

      def fields
        @@fields
      end

      def define_field_methods(name, kind, options={})
        define_method("#{name}=") do |val|
          @fields[name].value = val if @fields[name]
        end

        define_method("#{name}") do
          @fields[name].value if @fields[name]
        end
      end
    end
  end
end
