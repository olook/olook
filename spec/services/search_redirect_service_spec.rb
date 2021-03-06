require 'spec_helper'

describe SearchRedirectService do
  context "#path" do
    context "with text match" do
      it "should redirect to page" do
        expect(described_class.new("Olook movel").path).to eql(Rails.application.routes.url_helpers.olookmovel_path)
      end
    end
    context "without text match" do
      it "be false" do
        expect(described_class.new("Lucas").path).to be_false
      end
    end 
    context "with nil" do
      it "return false" do
        expect(described_class.new(nil).path).to eql(false)
      end
    end 
  end
end