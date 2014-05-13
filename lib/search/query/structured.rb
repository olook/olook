module Search
  module Query
    class Structured
      def initialize(base_class, operator)
        @base = base_class
        @operator = operator
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
        "(#{@operator} #{url.join(' ')})"
      end

      private
      def add_operator_node(kind, block)
        if kind == @operator
          block.call(self)
        else
          child_structured = self.class.new(@base, kind)
          block.call(child_structured)
          @nodes.push child_structured
        end
        self
      end

      def add_single_field(kind, name, value)
        if kind == @operator
          self.field(name, value)
        else
          self.send(kind) do |s|
            s.field name, value
          end
        end
        self
      end
    end
  end
end
