require 'spec_helper'

describe SearchUrlBuilder do

  URL_BASE = "searchdomain.com"

  describe "#initialize" do
    context "When receive attributes" do
      subject {described_class.new({category: 'sapato'})}
      it "fill respective fields" do
        expect(subject.expressions).to include(category: ['sapato'])
      end

      it "not fill strange keys" do
        subject {described_class.new({strange: 'sapato'})}
        expect(subject.expressions).to_not include(strange: ['sapato'])
      end
    end
  end


  context "with simple term" do
    subject {SearchUrlBuilder.new(URL_BASE).for_term("term")}

    it {expect(subject.build_url_for().to_s).to match(/\?q=term/)}

    context "and a color" do
      it {expect(subject.with_brand('brand').build_url_for().to_s).to match(/\?q=term&bq=(.*)%28field%20brand%20%27brand%27%29/)}
    end
  end

  context "without term" do
    subject {SearchUrlBuilder.new(URL_BASE)}

    it {expect(subject.build_url_for().to_s).to_not match(/#{URL_BASE}&/)}
    it {expect(subject.build_url_for().to_s).to_not match(/\?&/)}

    context "but with brand" do
      it {expect(subject.with_brand('brand').build_url_for().to_s).to match(/\?bq=(.*)%28field%20brand%20%27brand%27%29/)}
    end


  end

end
