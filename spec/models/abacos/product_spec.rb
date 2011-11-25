# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Product do
  let(:downloaded_product) { load_abacos_fixture :product }
  subject { described_class.new downloaded_product }

  let(:descritor_pre_definido)  { {:rows=>{:dados_descritor_pre_definido=>{:descricao=>"Couro Gergelim", :grupo_nome=>"COR  "}}} }
  let(:caracteristicas_complementares) { {:rows=>{:dados_caracteristicas_complementares=>[{:tipo_nome=>"Dica da Fernanda", :texto=>"Sapatilha sensaciona impressionantel!"}, {:tipo_nome=>"Perfil", :texto=>"Sexy, Casual "}]}} }
  
  describe 'attributes' do
    it '#integration_protocol' do
      subject.integration_protocol.should == "F248E8D4-7142-47B2-977E-97B0D0129C64"
    end

    it '#name' do
      subject.name.should == "Sapatilha Floral  com laço em couro verde"
    end

    it '#model_number' do
      subject.model_number.should == '1'
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
    
    it '#color' do
      subject.color.should == 'Floral'
    end
    
    it '#details' do
      subject.details.should == {"Dica da Fernanda"=>"Sapatilha sensaciona impressionantel!", "Altura do salto"=>"n/a", "Aviamento"=>"Preto", "Categoria"=>"Sapatilha", "Material externo"=>"Forro Cacharrel Natural", "Material interno"=>"Palm sint. Ouro light", "Material sola"=>"n/a", "Tipo do salto"=>"Baixo"}
    end
    
    it '#profiles' do
      subject.profiles.should == ['Sexy','Casual']
    end
  end

  describe '#integrate' do
    it 'should' do
      expect {
        subject.integrate
      }.to change(Product, :count).by(1)
    end
  end

  describe "#parse_color" do
    it "should return the color name" do
      subject.send(:parse_color, descritor_pre_definido).should == 'Couro Gergelim'
    end
  end

  describe "#parse_details" do
    it "should return product details from caracteristicas_complementares" do
      subject.send(:parse_details, caracteristicas_complementares).should == {"Dica da Fernanda"=>"Sapatilha sensaciona impressionantel!"}
    end
  end

  describe "#parse_profiles" do
    it "should return the profiles from caracteristicas_complementares" do
      subject.send(:parse_profiles, caracteristicas_complementares).should == ['Sexy', 'Casual']
    end
  end
end
