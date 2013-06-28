require 'spec_helper'

describe SearchUrlBuilder do

  URL_BASE = "searchdomain.com"


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
