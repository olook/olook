# -*- encoding : utf-8 -*-
module Abacos
  module TestHelpers
    def load_abacos_fixture(name)
      filename = Rails.root.join 'spec', 'abacos_fixtures', "#{name}.yml"
      File.exist?(filename) ? YAML.load(File.open(filename)) : {}
    end
  end
end
