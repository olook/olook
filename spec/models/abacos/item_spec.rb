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
  it '#preco_unitario_bruto' do
    subject.preco_unitario.should == '179.90'
  end

  context "without a liquidation" do
    describe '#parsed_data' do
      let(:expected_data) do
        {
          'CodigoProduto' => "#{line_item.variant.number}",
          'QuantidadeProduto' => line_item.quantity,
          'PrecoUnitario' => "#{"%.2f" % line_item.price}",
          'PrecoUnitarioBruto' => "#{"%.2f" % line_item.price}"
        }
      end

      it 'should return a hash properly formed' do
        subject.parsed_data.should == expected_data
      end
    end
  end

  context "with a liquidation" do
    describe '#parsed_data' do
      before :each do
        line_item.variant.stub(:liquidation?).and_return(true)
        line_item.update_attributes(:retail_price => @retail_price = 12.90)
      end
      let(:expected_data) do
        {
          'CodigoProduto' => "#{line_item.variant.number}",
          'QuantidadeProduto' => line_item.quantity,
          'PrecoUnitario' => "#{"%.2f" % @retail_price}",
          'PrecoUnitarioBruto' => "#{"%.2f" % line_item.price}"
        }
      end

      it 'should return a hash properly formed' do
       subject.parsed_data.should == expected_data
      end
    end
  end

end
