# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Item do
  let(:line_item) { FactoryGirl.create :line_item }
  subject { described_class.new line_item }

  it '#codigo' do
    subject.codigo.should == line_item.variant.number
  end
  it '#quantidade' do
    subject.quantidade.should == 2
  end
  it '#preco_unitario' do
    subject.preco_unitario.should == '179.90'
  end
  
  describe '#parsed_data' do
    let(:expected_data) do
      {
        'CodigoProduto' => line_item.variant.number,
        'QuantidadeProduto' => 2,
        'PrecoUnitario' => '179.90'
      }
    end

    it 'should return a hash properly formed' do
      subject.parsed_data.should == expected_data
    end
  end
end
