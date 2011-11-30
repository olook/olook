# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Product do
  let(:downloaded_product) { load_abacos_fixture :product }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_product }
  subject { described_class.new parsed_data }
  let!(:december_collection) { FactoryGirl.create(:collection) }

  it '#attributes' do
    subject.attributes.should == {  name:         subject.name,
                                    description:  subject.description,
                                    model_number: subject.model_number,
                                    category:     subject.category,
                                    color_name:   subject.color_name,
                                    width:        subject.width,
                                    height:       subject.height,
                                    length:       subject.length,
                                    weight:       subject.weight }
  end

  describe '#integrate' do
    let!(:sexy_profile) { FactoryGirl.create(:profile, :name => "Sexy", :first_visit_banner => 'sexy') }
    let!(:casual_profile) { FactoryGirl.create(:profile, :name => "Casual", :first_visit_banner => 'casual') }

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
      subject.should_receive(:integrate_profiles).with(mock_product)
      
      ::Product.stub(:find_by_model_number).with(subject.model_number).and_return(mock_product)

      Abacos::ProductAPI.should_receive(:confirm_product)
      
      subject.integrate
    end

    describe "helper methods" do
      it "#integrate_attributes" do
        mock_product = mock_model(::Product)
        mock_product.should_receive(:update_attributes).with(subject.attributes)
        mock_product.should_receive(:'collection=').with(december_collection)
        mock_product.should_receive(:'save!')
        subject.integrate_attributes mock_product
      end

      it "#integrate_details" do
        mock_details = double :details
        mock_details.should_receive(:destroy_all)
        mock_details.should_receive(:create).
                      with( :translation_token => 'detail_name',
                            :description => 'detail_description',
                            :display_on => DisplayDetailOn::DETAILS)
      
        mock_product = mock_model(::Product)
        mock_product.stub(:details).and_return(mock_details)
        
        subject.stub(:details).and_return({'detail_name' => 'detail_description'})

        subject.integrate_details mock_product
      end
      
      describe "#integrate_profiles" do
        let(:profile_a) { FactoryGirl.create :casual_profile }
        let(:profile_b) { FactoryGirl.create :sporty_profile }
        let(:mock_product) { mock_model(::Product) }
        let(:mock_product_profiles) { double :products_profiles }
        
        before :each do
          mock_product.stub(:profiles).and_return(mock_product_profiles)
          mock_product_profiles.should_receive(:destroy_all)
        end

        it "should iterate through the profiles and related them to the product" do
          subject.stub(:profiles).and_return([profile_a.name, profile_b.name])

          mock_product_profiles.should_receive(:'<<').with(profile_a)
          mock_product_profiles.should_receive(:'<<').with(profile_b)

          subject.integrate_profiles mock_product
        end

        it "should raise an error if any of the provided profiles doesn't exist" do
          subject.stub(:profiles).and_return(['non-existent-profile'])
          expect {
            subject.integrate_profiles mock_product
          }.to raise_error(RuntimeError, "Attemping to integrate invalid profile 'non-existent-profile'")
        end
      end
    end
  end

  describe "class methods" do
    let(:descritor_pre_definido)  { {:resultado_operacao => {:tipo => 'tdreSucesso'}, :rows=>{:dados_descritor_pre_definido=>{:descricao=>"Couro Gergelim", :grupo_nome=>"COR  "}}} }
    let(:caracteristicas_complementares) { {:resultado_operacao => {:tipo => 'tdreSucesso'}, :rows=>{:dados_caracteristicas_complementares=>[{:tipo_nome=>"Dica da Fernanda", :texto=>"Sapatilha sensaciona impressionantel!"}, {:tipo_nome=>"Perfil", :texto=>"Sexy, Casual "}]}} }

    describe '#parse_abacos_data' do
      it '#integration_protocol' do
        subject.integration_protocol.should == "F248E8D4-7142-47B2-977E-97B0D0129C64"
      end

      it '#name' do
        subject.name.should == "Sapatilha Floral  com laço em couro verde"
      end

      it '#description' do
        subject.description.should == "Descrição da Sapatilha Floral  com laço em couro verde"
      end

      it '#model_number' do
        subject.model_number.should == '1'
      end
      
      it '#category' do
        subject.category.should == Category::JEWEL
      end
      
      it '#color_name' do
        subject.color_name.should == "Floral"
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

      it '#collection_id' do
        subject.collection_id.should == december_collection.id
      end
      
      it '#details' do
        subject.details.should == {"Dica da Fernanda"=>"Sapatilha sensaciona impressionantel!", "Altura do salto"=>"n/a", "Aviamento"=>"Preto", "Categoria"=>"Sapatilha", "Material externo"=>"Forro Cacharrel Natural", "Material interno"=>"Palm sint. Ouro light", "Material sola"=>"n/a", "Tipo do salto"=>"Baixo"}
      end
      
      it '#profiles' do
        subject.profiles.should == ['Sexy','Casual']
      end
    end

    describe "#parse_description" do
      it "should return the name if the description is empty" do
        described_class.parse_description('name', '').should == 'name'
      end
      it "should return the description if it's not empty" do
        described_class.parse_description('name', 'description').should == 'description'
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

    describe "#parse_collection" do
      it "should return the id of a valid collection" do
        described_class.parse_collection('Coleção Dezembro').should == december_collection.id
      end
      describe "should return nil" do
        it "if the format is valid but there's no collection for the period" do
          described_class.parse_collection('Coleção Janeiro 2010').should be_nil
        end
        it "if collection data is empty" do
          described_class.parse_collection('  ').should be_nil
        end
      end
      it "should raise an error if the format is invalid" do
        expect {
          described_class.parse_collection('invalid data')
        }.to raise_error
      end
    end

    describe "#parse_collection_date" do
      describe "should return the reference date for the collection" do
        it "with default year 2011 when it's not informed" do
          described_class.parse_collection_date('Coleção Dezembro').should == Date.civil(2011, 12, 1)
        end
        it "with the parsed year when it is informed" do
          described_class.parse_collection_date('Coleção Abril/ 2010').should == Date.civil(2010, 4, 1)
        end
      end
      it 'should raise an error if it cannot process the collection' do
        expect {
          described_class.parse_collection_date('Coleção')
        }.to raise_error(RuntimeError, "Invalid collection 'Coleção'")
      end
    end
  end
end
