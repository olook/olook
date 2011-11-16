# -*- encoding : utf-8 -*-
require "spec_helper"

describe ImportFreightPricesWorker do
  let(:shipping_company) { FactoryGirl.create :shipping_company }
  let(:tempfile) { 'abc123.csv' }

  describe "#perform" do
    it 'should assign the shipping company' do
      ShippingCompany.should_receive(:find).with(shipping_company.id).and_return(shipping_company)
      shipping_company.freight_prices.should_receive(:destroy_all)
      described_class.stub(:load_data).and_return([])
      described_class.perform(shipping_company.id, tempfile)
    end
  end
  
  describe '#load_data' do
    let(:mock_uploader) { double :uploader }

    it 'should retrieve the stored file from S3' do
      CSV.stub(:read)
      mock_uploader.stub_chain(:file, :path)

      mock_uploader.should_receive('retrieve_from_store!').with(:filename)
      mock_uploader.should_receive('cache_stored_file!')
      TempFileUploader.stub(:new).and_return(mock_uploader)

      described_class.send :load_data, :filename
    end

    it 'should process the file through CSV' do
      mock_uploader.stub 'retrieve_from_store!'
      mock_uploader.stub 'cache_stored_file!'

      mock_uploader.stub_chain(:file, :path).and_return(:filename)
      TempFileUploader.stub(:new).and_return(mock_uploader)

      CSV.should_receive(:read).with(:filename)
      
      described_class.send :load_data, :filename
    end
  end
  
  describe '#create_freight' do
    let(:data) { 'TEX,1001000,1142100,SP,SAO PAULO,0.001,30.000,1,9.9,15,Atendida,Capital'.split ',' }
    it 'should properly parse the data from the file' do
      freight = described_class.create_freight(shipping_company, data)

      freight.should be_persisted

      freight.zip_start.should      == 1001000
      freight.zip_end.should        == 1142100
      freight.weight_start.should   == 0.001
      freight.weight_end.should     == 30.000
      freight.delivery_time.should  == 1
      freight.price.should          == 9.9
      freight.cost.should           == 15.0
      freight.description.should    == 'TEX - SP - SAO PAULO - Atendida - Capital'
    end
  end
end
