# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CollectionThemesHelper do

  describe "#installments" do
    context "when price is 83,56" do
      it "return '2 x de R$ 40,00'" do
        helper.installments(83.56).should == '2 x de R$ 41,78'
      end
    end

    context "when price is 23,53" do
      it "return '1 x de R$ 23,53'" do
        helper.installments(23.53).should == '1 x de R$ 23,53'
      end
    end

    context "when price is 420" do
      it "return '6 x de R$ 70,00'" do
        helper.installments(420).should == '6 x de R$ 70,00'
      end
    end
  end

  describe "#print_section_name" do
    context "when the request fullpath equals to an existing catalog section" do

      context "when the actions equals to '/bolsa'" do
        before do
          controller.request.stub(:fullpath).and_return('/bolsa')
        end
        it "returns bolsa" do
          helper.print_section_name.should == "bolsa"
        end
      end

      context "when the actions equals to '/sapato" do
        before do
          controller.request.stub(:fullpath).and_return('/sapato')
        end
        it "returns sapatos" do
          helper.print_section_name.should == "sapato"
        end
      end

      context "when the actions equals to '/acessorio'" do
        before do
          controller.request.stub(:fullpath).and_return('/acessorio')
        end
        it "returns acessórios" do
          helper.print_section_name.should == "acessório"
        end
      end

    end

    context "when the request fullpath isn't an exisitng catalog section " do
      before do
        controller.request.stub(:fullpath).and_return('/afsdoij')
      end
      it "returns nil" do
        helper.print_section_name.should be_nil
      end
    end
  end

end
