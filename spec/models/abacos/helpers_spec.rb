# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Helpers do
  class HelperClass
    include Abacos::Helpers
  end
  
  subject { HelperClass.new }

  describe '#parse_category' do
    it "should return Category::SHOE when classe is 'Sapato'" do
      subject.parse_category('Sapato').should == Category::SHOE
    end
    it "should return Category::BAG when classe is 'Bolsa'" do
      subject.parse_category('Bolsa').should == Category::BAG
    end
    it "should return Category::JEWEL when classe is 'Jóia'" do
      subject.parse_category('Jóia').should == Category::JEWEL
    end
    it "should return Category::SHOE when classe something else" do
      subject.parse_category('XXX').should == Category::SHOE
    end
  end
end
