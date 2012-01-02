# -*- encoding : utf-8 -*-
require "spec_helper"

describe Abacos::Payment do
  let(:payment) { double(:payment, :bank => "Bamerindus", :payments => 3) }
  let(:order) { double(:order, :total_with_freight => 103.00, :payment => payment) }
  subject { Abacos::Payment.new(order) }

  describe "#initialize" do

    it "gets total with freight from order" do
      order.should_receive(:total_with_freight)
      Abacos::Payment.new(order)
    end

    it "sets valor with total with freight value" do
      Abacos::Payment.new(order).valor.should == "103.00"
    end

    describe "#forma" do
      let(:payment) { double(:payment, :bank => "Bamerindus", :payments => 3) }
      let(:order) { double(:order, :total_with_freight => 103.00, :payment => payment) }

      context "when payment type is Boleto" do
        it "sets forma to BOLETO" do
          payment.stub(:is_a?).with(Billet).and_return(true)
          Abacos::Payment.new(order).forma.should == "BOLETO"
        end
      end

      context "when payment type is not Boleto" do
        it "sets forma to bank's name" do
          payment.stub(:is_a?).with(Billet).and_return(false)
          Abacos::Payment.new(order).forma.should == "BAMERINDUS"
        end
      end

    end

    describe "#parcelas" do
      context "when payment payments is nil" do
        it "returns 1" do
          payment.stub(:payments).and_return(nil)
          Abacos::Payment.new(order).parcelas.should == 1
        end
      end

      context "when payment payments is not nil" do
        it "returns payments" do
          payment.stub(:payments).and_return(5)
          Abacos::Payment.new(order).parcelas.should == 5
        end
      end
    end

  end

  describe "#parsed_data" do
    it "returns hash with valor parcelas and forma attributes" do
      data = {
              "DadosPedidosFormaPgto"=>
                {
                  "Valor"=>"103.00",
                  "CartaoQtdeParcelas"=>3,
                  "FormaPagamentoCodigo"=>"BAMERINDUS"
                }
              }
      subject.parsed_data.should == data
    end
  end

end