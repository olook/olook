# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Product do
  let(:downloaded_product) { load_abacos_fixture :product }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_product }
  subject { described_class.new parsed_data }
  let!(:december_collection) { FactoryGirl.create(:collection) }

  let(:descritor_simples) {
    {:versao_web_service=>"5.0B.0057", :resultado_operacao=>{:codigo=>"200003", :descricao=>"OK, porém não há dados.", :tipo=>"tdreSucessoSemDados"}, :rows=>{:dados_descritor_simples=>{:codigo_interno=>"0", :numero=>"0", :descricao=>nil}}}
  }

  it '#attributes' do
    subject.attributes.should == {  name:          subject.name,
                                    description:   subject.description,
                                    model_number:  subject.model_number,
                                    category:      subject.category,
                                    color_name:    subject.color_name,
                                    width:         subject.width,
                                    height:        subject.height,
                                    length:        subject.length,
                                    weight:        subject.weight,
                                    is_kit:        subject.is_kit,
                                    producer_code: subject.producer_code,
                                    brand:         subject.brand }
  end

  describe '#integrate' do

     before :all do
      Profile.destroy_all
      CollectionTheme.destroy_all
    end

    let!(:sexy_profile) { FactoryGirl.create(:profile, :name => "Sexy", :first_visit_banner => 'sexy') }
    let!(:casual_profile) { FactoryGirl.create(:profile, :name => "Casual", :first_visit_banner => 'casual') }
    let!(:collection_theme) { FactoryGirl.create(:collection_theme, :id => 1) }

    it 'should create a new product' do
      expect {
        subject.stub(:integrate_details)
        subject.stub(:integrate_profiles)
        subject.stub(:integrate_catalogs)
        subject.stub(:confirm_product)
        subject.integrate
      }.to change(Product, :count).by(1)
    end

    it 'should call the integration confirmation' do
      subject.stub(:integrate_details)
      subject.should_receive(:confirm_product)
      subject.integrate
    end

    it 'should call the merging methods on the product and confirm it' do
      mock_product = mock_model(::Product)
      subject.should_receive(:find_or_initialize_product).and_return(mock_product)
      subject.should_receive(:integrate_attributes).with(mock_product)
      subject.should_receive(:integrate_details).with(mock_product)
      subject.should_receive(:integrate_profiles).with(mock_product)
      subject.should_receive(:integrate_catalogs).with(mock_product)
      subject.should_receive(:confirm_product)

      subject.integrate
    end

    describe "a product that is a kit" do
      it 'should call the merging methods on the product and create kit variant it' do
        mock_product = mock_model(::Product)
        mock_product.stub(:is_kit).and_return true
        subject.should_receive(:find_or_initialize_product).and_return(mock_product)
        subject.should_receive(:integrate_attributes).with(mock_product)
        subject.should_receive(:integrate_details).with(mock_product)
        subject.should_receive(:integrate_profiles).with(mock_product)
        subject.should_receive(:integrate_catalogs).with(mock_product)
        subject.should_receive(:create_kit_variant)
        subject.integrate
      end
    end

    describe "helper methods" do
      it "#integrate_attributes" do
        mock_product = mock_model(::Product)
        mock_product.should_receive(:update_attributes).with(subject.attributes)
        mock_product.should_receive(:'collection=').with(december_collection)
        mock_product.should_receive(:'save!')
        subject.integrate_attributes mock_product
      end

      it "#integrate_catalogs" do
        mock_product = mock_model(::Product)
        CatalogService.should_receive(:save_product)
                      .with(mock_product, :collection_themes => [collection_theme])

        subject.integrate_catalogs mock_product
      end

      it "#integrate_details" do
        mock_details = double :details
        mock_details.should_receive(:destroy_all)
        mock_details.should_receive(:create).
                      with( :translation_token => 'detail_name',
                            :description => 'detail_description',
                            :display_on => DisplayDetailOn::SPECIFICATION)

        mock_product = mock_model(::Product)
        mock_product.stub(:details).and_return(mock_details)

        subject.should_receive(:integrate_how_to).with(mock_product)
        subject.stub(:details).and_return({'detail_name' => 'detail_description'})

        subject.integrate_details mock_product
      end

      it '#integrate_how_to' do
        mock_details = double :details
        mock_details.should_receive(:create).
                      with( :translation_token => 'Como vestir',
                            :description => 'how to wear',
                            :display_on => DisplayDetailOn::HOW_TO)

        mock_product = mock_model(::Product)
        mock_product.stub(:details).and_return(mock_details)

        subject.stub(:how_to).and_return('how to wear')

        subject.integrate_how_to mock_product
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

      describe "#confirm_product" do
        let(:fake_protocol) { 'PROT123' }
        let(:fake_product_model_number) { 'PROT123' }
        before do
          subject.stub(:integration_protocol).and_return(fake_protocol)
          subject.stub(:model_number).and_return(fake_product_model_number)
        end
        it 'should add a task on the queue to integrate' do
          Resque.should_receive(:enqueue).with(Abacos::ConfirmProduct, fake_protocol, fake_product_model_number)
          subject.confirm_product
        end
      end

      describe "#create_kit_variant" do
        let(:fake_data) { {:key => 'value'} }
        it 'should add a task on the queue to integrate' do
          subject.stub(:create_abacos_kit_variant_data).and_return(fake_data)
          Resque.should_receive(:enqueue).with(Abacos::Integrate, Abacos::Variant.to_s, fake_data)
          subject.create_kit_variant
        end
      end
    end

    describe "parser collection themes" do
      describe "when has many collection themes" do
        it "should return collection themes" do
          parsed_data[:collection_themes].should == ["1", "2"]
        end
      end

      describe "when has only one collection theme" do
        let(:downloaded_product) { load_abacos_fixture :product_one_category }
        let(:parsed_data) { described_class.parse_abacos_data downloaded_product }

        it "should return collection theme" do
          parsed_data[:collection_themes].should == ["1"]
        end
      end
    end
  end

  describe "class methods" do
    let(:descritor_pre_definido)  { {:resultado_operacao => {:tipo => 'tdreSucesso'}, :rows=>{:dados_descritor_pre_definido=>{:descricao=>"Couro Gergelim", :grupo_nome=>"COR  "}}} }
    let(:caracteristicas_complementares) { {:resultado_operacao => {:tipo => 'tdreSucesso'}, :rows=>{:dados_caracteristicas_complementares=>[{:tipo_nome=>"Dica da Fernanda", :texto=>"Sapatilha sensaciona impressionantel!"}, {:tipo_nome=>"Perfil", :texto=>"Sexy, Casual "}, {:tipo_nome=>"Salto", :texto=>"DeFault "}, {:tipo_nome=>"Como vestir", :texto=>"Deve-se vestir no pé"}, {:tipo_nome=>"Descrição", :texto=>"O cetim e o strass formam uma ótima combinação, pronta para ir para uma festa?"}]}} }

    describe '#parse_abacos_data' do
      it '#integration_protocol' do
        subject.integration_protocol.should == "F248E8D4-7142-47B2-977E-97B0D0129C64"
      end

      it '#name' do
        subject.name.should == "Florzinha"
      end

      it '#description' do
        subject.description.should == "O cetim e o strass formam uma ótima combinação, pronta para ir para uma festa?"
      end

      it '#model_number' do
        subject.model_number.should == '1'
      end

      it '#category' do
        subject.category.should == Category::ACCESSORY
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
        subject.details.should == {"Dica da Fernanda"=>"Sapatilha sensaciona impressionantel!", "Altura do salto"=>"n/a", "Aviamento"=>"Preto", "Categoria"=>"Sapatilha", "Material externo"=>"Forro Cacharrel Natural", "Material interno"=>"Palm sint. Ouro light", "Material sola"=>"n/a", "Tipo do salto"=>"Baixo", "Cor fornecedor"=>"Vermelho", "Cor produto"=>"Vermelho Sunset"}
      end

      it '#how_to' do
        subject.how_to.should == "Deve-se vestir no pé"
      end

      it '#profiles' do
        subject.profiles.should == ['Sexy','Casual']
      end
    end

    describe "#parse_description" do
      it "should return product description from caracteristicas_complementares" do
        described_class.parse_description(caracteristicas_complementares, 'Fallback name').should == "O cetim e o strass formam uma ótima combinação, pronta para ir para uma festa?"
      end

      it "should return product description from caracteristicas_complementares" do
        empty_data = {:resultado_operacao => {:tipo => 'tdreSucesso'}, :rows=>{:dados_caracteristicas_complementares=>[]}}
        described_class.parse_description(empty_data, 'Fallback name').should == "Fallback name"
      end
    end

    describe "#parse_name" do
      it "should return the name when it's not empty" do
        described_class.parse_name('beach name', 'fallback').should == 'beach name'
      end
      it "should return the fallback when the name is empty" do
        described_class.parse_name('', 'fallback').should == 'fallback'
      end
    end

    describe "#parse_color" do
      it "should return the color name" do
        described_class.parse_color(descritor_pre_definido).should == 'Couro Gergelim'
      end
    end

    describe "#parse_details" do
      it "should return product details from caracteristicas_complementares" do
        described_class.parse_details(caracteristicas_complementares, descritor_simples)
      end
    end

    describe "#parse_how_to" do
      it "should return product how to use text from caracteristicas_complementares" do
        described_class.parse_how_to(caracteristicas_complementares).should == "Deve-se vestir no pé"
      end
    end

    describe "#parse_profiles" do
      it "should return the profiles from caracteristicas_complementares" do
        described_class.parse_profiles(caracteristicas_complementares).should == ['Sexy', 'Casual']
      end
    end

    describe "#parse_collection" do
      it "should return the id of a valid collection" do
        described_class.parse_collection('Coleção Dezembro 2011').should == december_collection.id
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
          described_class.parse_collection_date('Coleção Dezembro 2011').should == Date.civil(2011, 12, 1)
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

    describe "#keys_to_symbol" do

      it "should change string key to symbol" do
        params = {"string_key" => "value"}
        result = subject.send :keys_to_symbol, params
        result.should eq({:string_key => "value"})
      end

      it "should change sub-hashes keys to symbol" do
        params = {:key => {"string_key" => "value"}}
        result = subject.send :keys_to_symbol, params
        result.should eq({:key => {:string_key => "value"}})
      end

    end
  end

end
