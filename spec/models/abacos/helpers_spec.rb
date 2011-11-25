# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Helpers do
  class HelperClass
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
    it "should return Category::JEWEL when classe is 'Jóia'" do
      subject.parse_category('Jóia').should == Category::JEWEL
    end
    it "should return Category::SHOE when classe something else" do
      subject.parse_category('XXX').should == Category::SHOE
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
end
