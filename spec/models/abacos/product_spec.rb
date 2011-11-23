# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Product do
  let(:downloaded_product) { load_fixture :product }
  subject { described_class.new downloaded_product }
  
  describe 'attributes' do
    it '#name' do
      subject.name.should == "Sandália com Flor de couro Coral"
    end

    it '#model_name' do
      subject.model_name.should == '10'
    end
    
    it '#category' do
      subject.category.should == Category::JEWEL
    end
    
    it '#width' do
      subject.width.should == 25.0
    end
    
    it '#height' do
      subject.height.should == 10.5
    end
    
    it '#length' do
      subject.length.should == 29.5
    end
    
    it '#weight' do
      subject.weight.should == 0.6
    end
  end
  
  describe '#parse_category' do
    it "should return Category::SHOE when classe is 'Sapato'" do
      subject.send(:parse_category, 'Sapato').should == Category::SHOE
    end
    it "should return Category::BAG when classe is 'Bolsa'" do
      subject.send(:parse_category, 'Bolsa').should == Category::BAG
    end
    it "should return Category::JEWEL when classe is 'Jóia'" do
      subject.send(:parse_category, 'Jóia').should == Category::JEWEL
    end
    it "should return Category::SHOE when classe something else" do
      subject.send(:parse_category, 'XXX').should == Category::SHOE
    end
  end
private
  def load_fixture(name)
    filename = File.join File.expand_path(File.dirname( __FILE__ )), "#{name}.yml"
    File.exist?(filename) ? YAML.load(File.open(filename)) : {}
  end
end
