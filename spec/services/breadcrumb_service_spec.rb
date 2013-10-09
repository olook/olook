require "spec_helper"

describe BreadcrumbService do
  let(:product) { FactoryGirl.build(:shoe, :casual) }

  describe "#product_breadcrumbs_for" do
    context "receiving a product" do
      it "generates an array of hashes, each containing the link title and url" do
        described_class.product_breadcrumbs_for(product).should eq([described_class.home_url,{name: product.category_humanize.titleize.pluralize, url: "/#{product.category_humanize.downcase}"}])
      end
    end
  end
end