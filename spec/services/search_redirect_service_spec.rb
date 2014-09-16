require 'spec_helper'

describe SearchRedirectService do
  context "#should_redirect" do
    context "without text match" do
      it "return false" do
        expect(described_class.new("").should_redirect?).to eql(false) 
      end
    end
    context "with nil" do
      it "return false" do
        expect(described_class.new(nil).should_redirect?).to eql(false)
      end
    end
    context "with text match" do
      it "return true" do
        expect(described_class.new("olook movel").should_redirect?).to eql(true)
      end	
      it "return true even in a different syntax" do
      	expect(described_class.new("Olook movel").should_redirect?).to eql(true)
      end
    end  
  end
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
  end
end