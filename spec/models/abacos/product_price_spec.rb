# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::ProductPrice do
  let(:downloaded_price) { load_abacos_fixture :product_price }
  let(:parsed_data) { described_class.parse_abacos_data downloaded_price }

  subject { described_class.new parsed_data }
  
  describe '#integrate' do
    it "should raise and error if the related Product doesn't exist" do
      expect {
        ::Product.should_receive(:find_by_model_number).with(subject.model_number).and_return(nil)
        subject.integrate
      }.to raise_error "Price is related with Product model number #{subject.model_number}, but it doesn't exist"
    end

    it 'should update the product price and integrate it' do
      mock_product = mock_model(::Product)
      mv = mock_model(::Variant)
      mv.stub(:'price=' => nil, :'retail_price=' => nil, :'save!' => nil)
      mock_product.stub(:master_variant).and_return(mv)
      mock_product.should_receive(:'price=').with(subject.price)
      mock_product.should_receive(:'retail_price=').with(subject.retail_price)
      mock_product.should_receive(:'save!').and_return(true)
      ::Product.should_receive(:find_by_model_number).with(subject.model_number).and_return(mock_product)
      CatalogService.should_receive(:save_product).with(mock_product, :update_price => true)

      subject.should_receive(:confirm_price)
      
      subject.integrate
    end

    it 'should update the kit product price and update kit variant price' do
      mock_product = mock_model(::Product)
      mv = mock_model(::Variant)
      mv.stub(:'price=' => nil, :'retail_price=' => nil, :'save!' => nil)
      mock_product.stub(:master_variant).and_return(mv)
      mock_product.should_receive(:'price=').with(subject.price)
      mock_product.should_receive(:'retail_price=').with(subject.retail_price)
      mock_product.should_receive(:'save!').and_return(true)
      mock_product.should_receive(:is_kit).and_return(true)
      ::Product.should_receive(:find_by_model_number).with(subject.model_number).and_return(mock_product)
      CatalogService.should_receive(:save_product).with(mock_product, :update_price => true)

      subject.should_receive(:update_kit_variant_price)
      
      subject.integrate
    end
  end
  
  describe "#confirm_price" do
    let(:fake_protocol) { 'PROT-123-PRICE' }
    it 'should add a task on the queue to integrate' do
      subject.stub(:integration_protocol).and_return(fake_protocol)
      Resque.should_receive(:enqueue).with(Abacos::ConfirmPrice, fake_protocol)
      subject.confirm_price
    end
  end

  describe '#parse_abacos_data' do
    it '#integration_protocol' do
      subject.integration_protocol.should == "999D8382-BA36-4AB4-A9FC-5BEFA60F58D7"
    end
    it '#model_number' do
      subject.model_number.should == "66"
    end
    it '#price' do
      subject.price.should == 69.9
    end
    it '#retail_price' do
      subject.retail_price.should == 0.0
    end
  end
end
