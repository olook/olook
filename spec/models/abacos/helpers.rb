# -*- encoding : utf-8 -*-
module RSpec
  module Abacos
    module Helpers
      def load_fixture(name)
        filename = File.join File.expand_path(File.dirname( __FILE__ )), "#{name}.yml"
        File.exist?(filename) ? YAML.load(File.open(filename)) : {}
      end
    end
  end
end
