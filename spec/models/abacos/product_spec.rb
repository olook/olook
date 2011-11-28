# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Product do
  let(:downloaded_product) { load_abacos_fixture :product }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_product }
  subject { described_class.new parsed_data }

  it '#attributes' do
    subject.attributes.should == {  name:         subject.name,
                                    model_number: subject.model_number,
                                    category:     subject.category,
                                    width:        subject.width,
                                    height:       subject.height,
                                    length:       subject.length,
                                    weight:       subject.weight }
  end

  describe '#integrate' do
    it 'should create a new product' do
      Abacos::ProductAPI.should_receive(:confirm_product)
      expect {
        subject.stub(:integrate_details)
        subject.integrate
      }.to change(Product, :count).by(1)
    end

    it 'should call the integration confirmation' do
      subject.stub(:integrate_details)
      Abacos::ProductAPI.should_receive(:confirm_product).with(subject.integration_protocol)
      subject.integrate
    end

    it 'should merge the imported attributes on the product' do
      mock_product = mock_model(::Product)

      subject.should_receive(:integrate_attributes).with(mock_product)
      subject.should_receive(:integrate_details).with(mock_product)
      mock_product.should_receive(:'save!')
      
      ::Product.stub(:find_by_model_number).with(subject.model_number).and_return(mock_product)

      Abacos::ProductAPI.should_receive(:confirm_product)
      
      subject.integrate
    end

    describe "helper methods" do
      it "#integrate_attributes" do
        mock_product = mock_model(::Product)
        mock_product.should_receive(:update_attributes).with(subject.attributes)
        mock_product.should_receive(:'description')
        mock_product.should_receive(:'description=')
        subject.integrate_attributes mock_product
      end

      it "#integrate_details" do
        mock_details = double :details
        mock_details.should_receive(:build).
                      with( :translation_token => 'detail_name',
                            :description => 'detail_description',
                            :display_on => DisplayDetailOn::DETAILS)
      
        mock_product = mock_model(::Product)
        mock_product.stub(:details).and_return(mock_details)
        
        subject.stub(:details).and_return({'detail_name' => 'detail_description'})

        subject.integrate_details mock_product
      end
    end
  end

  describe "class methods" do
    let(:descritor_pre_definido)  { {:rows=>{:dados_descritor_pre_definido=>{:descricao=>"Couro Gergelim", :grupo_nome=>"COR  "}}} }
    let(:caracteristicas_complementares) { {:rows=>{:dados_caracteristicas_complementares=>[{:tipo_nome=>"Dica da Fernanda", :texto=>"Sapatilha sensaciona impressionantel!"}, {:tipo_nome=>"Perfil", :texto=>"Sexy, Casual "}]}} }

    describe '#parse_abacos_data' do
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

    describe "#parse_color" do
      it "should return the color name" do
        described_class.parse_color(descritor_pre_definido).should == 'Couro Gergelim'
      end
    end

    describe "#parse_details" do
      it "should return product details from caracteristicas_complementares" do
        described_class.parse_details(caracteristicas_complementares).should == {"Dica da Fernanda"=>"Sapatilha sensaciona impressionantel!"}
      end
    end

    describe "#parse_profiles" do
      it "should return the profiles from caracteristicas_complementares" do
        described_class.parse_profiles(caracteristicas_complementares).should == ['Sexy', 'Casual']
      end
    end
  end
end
