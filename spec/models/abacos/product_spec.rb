# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Product do
  let(:downloaded_product) { load_abacos_fixture :product }
  subject { described_class.new downloaded_product }
  
  describe 'attributes' do
    it '#name' do
      subject.name.should == "Sapatilha Floral  com laço em couro verde"
    end

    it '#model_name' do
      subject.model_name.should == '1'
    end
    
    it '#category' do
      subject.category.should == Category::JEWEL
    end
    
    it '#color' do
      subject.color.should == "Floral"
    end

    it '#width' do
      subject.width.should == 19.0
    end
    
    it '#height' do
      subject.height.should == 10.5
    end
    
    it '#length' do
      subject.length.should == 29.9
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
  
  describe "#parse_color" do
    it "should return the color name" do
      abacos_descritor_pre_definido = {:versao_web_service=>"5.0B.0057", :resultado_operacao=>{:codigo=>"200001", :descricao=>"Operação \"Listar os descritores pré-definidos associados ao produto\" efetuada com sucesso.", :tipo=>"tdreSucesso"}, :rows=>{:dados_descritor_pre_definido=>{:codigo_interno=>"1", :numero=>"1", :descricao=>"Couro Gergelim", :grupo_codigo=>"1", :grupo_nome=>"COR                                               "}}}
      subject.send(:parse_color, abacos_descritor_pre_definido).should == 'Couro Gergelim'
    end
  end
end
