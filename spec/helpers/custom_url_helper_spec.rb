# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CustomUrlHelper do
  describe "#retreive_filter" do
    context "When request full path equals to /sapato" do
      before do
        controller.request.stub(:fullpath).and_return('/sapato')
      end
      it "returns catalog catalog filter and category" do
        expect(retreive_filter(controller.request.fullpath)).to eql ["catalog/filters", "sapato"]
      end
    end
    context "When request full path equals to /colecoes" do
      before do
        controller.request.stub(:fullpath).and_return('/colecoes')
      end
      it "returns catalog collection_themes filter" do
        expect(retreive_filter(controller.request.fullpath)).to eql "collection_themes/menu"
      end
    end
    context "When request full path equals to /marcas" do
      before do
        controller.request.stub(:fullpath).and_return('/marcas')
      end
      it "returns catalog brands filter" do
        expect(retreive_filter(controller.request.fullpath)).to eql "brands/side_filters"
      end
    end
  end
end
