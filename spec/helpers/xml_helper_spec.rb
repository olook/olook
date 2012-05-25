# -*- encoding : utf-8 -*-
require 'spec_helper'

describe XmlHelper do
  describe "build_installment_text" do

    context "when the product price is equal to 24.90" do
      it "returns the number of installments and the value of each installment" do
         helper.build_installment_text(BigDecimal.new("24.90")).should == "1 x 24,90"
      end
    end

    context "when product price is equal to 69.90" do
      it "returns the number of installments and the value of each installment" do
         helper.build_installment_text(BigDecimal.new("69.90")).should == "2 x 34,95"
      end
    end

    context "when product price is equal to 99.90" do
      it "returns the number of installments and the value of each installment" do
         helper.build_installment_text(BigDecimal.new("99.90")).should == "3 x 33,30"
      end
    end

    context "when product price is equal to 129.90" do
      it "returns the number of installments and the value of each installment" do
        helper.build_installment_text(BigDecimal.new("129.90")).should == "4 x 32,48"
      end
    end

  end

  describe "full_category" do
    let(:product) { double(:product, :category => "Sapato")}

    context "when product has only category" do
      before do
        product.stub(:subcategory).and_return(nil)
      end

      it "returns its category" do
        helper.full_category(product).should == "Sapato"
      end
    end

    context "when product has a subcategory" do
      before do
        product.stub(:subcategory).and_return("peep toe")
      end

      it "returns its category followed by the subcategory" do
        helper.full_category(product).should == "Sapato - peep toe"
      end
    end

  end
end
