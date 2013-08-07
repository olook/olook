# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Helpers do
  class HelperClass
    def wsdl
      :fake_wsdl_url
    end
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
    it "should return Category::ACCESSORY when classe is 'Jóia'" do
      subject.parse_category('Jóia').should == Category::ACCESSORY
    end
    it "should return Category::ACCESSORY when classe is 'Joia'" do
      subject.parse_category('Joia').should == Category::ACCESSORY
    end
    it "should return Category::CLOTH when classe something else" do
      subject.parse_category('XXX').should == Category::CLOTH
    end
  end
  
  it '#raise_webservice_error' do
    error_response = {method: 'WS123', codigo: 13, tipo: 'tdreErro',
                      descricao: 'Descricao Erro', exception_message: 'Exception'}
    expected_error_message = "Error calling webservice WS123: (13) tdreErro - Descricao Erro - Exception"
    expect {
      subject.raise_webservice_error(error_response)
    }.to raise_error(RuntimeError, expected_error_message)
  end
  
  describe '#parse_nested_data' do
    it "should return an empty array if the call was successful but didn't return any data" do
      without_data = {:resultado_operacao => {:tipo => 'tdreSucessoSemDados'}}
      result= subject.parse_nested_data(without_data, :some_key)
      result.should == []
    end
    context "if the call was successful and has data" do
      it "should enclose the data in a array if it isn't already" do
        with_data_not_array = {:resultado_operacao => {:tipo => 'tdreSucesso'}, :rows => {:some_key => :some_value} }
        result = subject.parse_nested_data(with_data_not_array, :some_key)
        result.should == [:some_value]
      end
      it "should return the data if it is an array" do
        with_data_array = {:resultado_operacao => {:tipo => 'tdreSucesso'}, :rows => {:some_key => [:some_value, nil]} }
        result = subject.parse_nested_data(with_data_array, :some_key)
        result.should == [:some_value]
      end
    end
    it "should raise an error if the call wasn't successful" do
      with_error = {:resultado_operacao => {:tipo => 'tdreErroDataBase'} }
      expect {
        subject.parse_nested_data(nested_data_with_error, :some_key)
      }.to raise_error
    end
  end

  it '#download_xml' do
    subject.should_receive(:call_webservice).with(:fake_wsdl_url, :method).and_return(:ws_result)
    subject.should_receive(:parse_nested_data).with(:ws_result, :key)
    subject.download_xml(:method, :key)
  end
  
  it '#parse_datetime' do
    datetime = DateTime.civil(2012, 04, 12, 10, 44, 55)
    subject.parse_datetime(datetime).should == '12042012 10:44:55'
  end
end
