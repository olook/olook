require 'spec_helper'

describe SearchUrlBuilder do

  URL_BASE = "searchdomain.com"


  context "with simple term" do
    subject {SearchUrlBuilder.new(URL_BASE).for_term("term")}

    it {expect(subject.build_url.to_s).to match(/#{URL_BASE}\?q=term/)}

    context "and a color" do
      it {expect(subject.with_brand('brand').build_url.to_s).to match(/#{URL_BASE}\?q=term&bq=brand%3A%27brand%27/)}
    end

    context "and a model_name" do
      it {expect(subject.with_model_name('model_name').build_url.to_s).to match(/\?q=term&bq=categoria%3A%27model_name%27/)}
    end
  end

  context "without term" do
    subject {SearchUrlBuilder.new(URL_BASE)}

    it {expect(subject.build_url.to_s).to_not match(/#{URL_BASE}&/)}
    it {expect(subject.build_url.to_s).to_not match(/\?&/)}

    context "but with model_name" do
      it {expect(subject.with_model_name('model_name').build_url.to_s).to match(/\?bq=categoria%3A%27model_name%27/)}

      context "and brand" do
        it {expect(subject.with_model_name('model_name').with_brand("brand").build_url.to_s).to match(/\?bq=%28and%20categoria%3A%27model_name%27%20brand%3A%27brand%27%29/)}
      end
    end

    context "but with brand" do
      it {expect(subject.with_brand('brand').build_url.to_s).to match(/\?bq=brand%3A%27brand%27/)}
    end


  end

end
