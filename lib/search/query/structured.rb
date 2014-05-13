module Search
  module Query
    class Structured
      attr_reader :nodes
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

      def nodes_by_field(_nodes_by_field={})
        nodes.each do |node|
          if node.respond_to?(:name)
            _nodes_by_field[node.name.to_s] ||= []
            _nodes_by_field[node.name.to_s].push(node.value)
            _nodes_by_field[node.name.to_s].flatten!
          elsif node.respond_to?(:nodes_by_field)
            node.nodes_by_field(_nodes_by_field)
          end
        end
        _nodes_by_field
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
          if child_structured.nodes.size < 2
            @nodes.concat(child_structured.nodes)
          else
            @nodes.push child_structured
          end
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
