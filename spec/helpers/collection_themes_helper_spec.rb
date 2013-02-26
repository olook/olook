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

    context "when price is 400" do
      it "return '10 x de R$ 40,00'" do
        helper.installments(400).should == '10 x de R$ 40,00'
      end
    end
  end

  describe "#print_section_name" do
    context "when the request fullpath equals to an existing catalog section" do

      context "when the actions equals to '/bolsas'" do
        before do
          controller.request.stub(:fullpath).and_return('/bolsas')
        end
        it "returns bolsas" do
          helper.print_section_name.should == "bolsas"
        end
      end

      context "when the actions equals to '/sapatos" do
        before do
          controller.request.stub(:fullpath).and_return('/sapatos')
        end
        it "returns sapatos" do
          helper.print_section_name.should == "sapatos"
        end
      end

      context "when the actions equals to '/acessorios'" do
        before do
          controller.request.stub(:fullpath).and_return('/acessorios')
        end
        it "returns acessórios" do
          helper.print_section_name.should == "acessórios"
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
