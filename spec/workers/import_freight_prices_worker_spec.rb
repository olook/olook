# -*- encoding : utf-8 -*-
require "spec_helper"

describe ImportFreightPricesWorker do
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:tempfile) { 'abc123.csv' }

  describe "#perform" do
    it 'should assign the shipping service' do
      ShippingService.should_receive(:find).with(shipping_service.id).and_return(shipping_service)
      shipping_service.freight_prices.should_receive(:destroy_all)
      described_class.stub(:load_data).and_return([])
      described_class.perform(shipping_service.id, tempfile)
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

      CSV.should_receive(:read).with(:filename, {:col_sep => ';'})
      
      described_class.send :load_data, :filename
    end
  end
  
  describe '#create_freight' do
    # Expected 12 columns:
    # - Transportador
    # - CEP inicial
    # - CEP final
    # - UF
    # - Nome do Município (Base IBGE)
    # - Preço inicio
    # - Preço fim
    # - Prazo
    # - Receita
    # - Custo
    # - Localidade Atendida
    # - Tipo de Localidade Comercial
    let(:data) { 'TEX;1001000;1142100;SP;SAO PAULO;0,001;30,000;1;R$ 9,9;R$ 15,0;Atendida;Capital'.split ';' }

    it 'should properly parse the data from the file' do
      freight = described_class.create_freight(shipping_service, data)

      freight.should be_persisted

      freight.zip_start.should          == 1001000
      freight.zip_end.should            == 1142100
      freight.order_value_start.should  be_within(0.001).of(0.001)
      freight.order_value_end.should    be_within(0.001).of(30.000)
      freight.delivery_time.should      == 1
      freight.price.should              be_within(0.001).of(9.9)
      freight.cost.should               be_within(0.001).of(15.0)
      freight.description.should        == 'TEX - SP - SAO PAULO - Atendida - Capital'
    end
  end
  
  describe '#parse_float, should return a valid BigDecimal given' do
    it 'R$ 9,123 should return 9.123' do
      described_class.parse_float('R$ 9,123').should be_within(0.0001).of(9.123)
    end
    it 'US$ 9.14 should return 9.14' do
      described_class.parse_float('US$ 9.14').should be_within(0.0001).of(9.14)
    end
  end
end
