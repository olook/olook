module Search
  module Query
    class Structured
      def initialize(base_class)
        @base = base_class
        @nodes = []
      end

      def field(key, value, options={})
        node = @base.field(key.to_s, options) || Field.new(key, @base, options)
        node.value = value
        @nodes << node
      end

      [:and, :or, :not].each do |m|
        define_method m do |field=nil, value=nil, &block|
          if block
            add_operator_node(m, block)
          else
            add_single_field(m, field, value)
          end
        end
      end

      def to_url
        url = @nodes.map do |node|
          node.to_url
        end
        url.join(' ')
      end

      private
      def add_operator_node(kind, block)
        child_structured = self.class.new(@base)
        block.call(child_structured)
        @nodes << Operator.new(kind, child_structured)
        self
      end

      def add_single_field(kind, name, value)
        child_structured = self.class.new(@base)
        child_structured.send(kind) do |s|
          s.field name, value
        end
        @nodes << child_structured
        self
      end
    end
  end
end
