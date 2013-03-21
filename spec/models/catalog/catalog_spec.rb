# encoding: utf-8
require 'spec_helper'

describe Catalog::Catalog do
  it { should_not allow_value("Catalog::Catalog").for(:type) }
  it { should validate_presence_of(:type) }
  it { should have_many(:products)}

  describe '#cloth_sizes' do
    before do
      @collection_theme = FactoryGirl.create(:collection_theme)
      @catalog_product = FactoryGirl.create(:catalog_product,
                                            catalog: @collection_theme.catalog,
                                            category_id: Category::CLOTH,
                                            cloth_size: 'PP')
    end
    subject { @collection_theme.catalog.cloth_sizes }
    it { should eql(['PP'])}

    context 'order' do
      before do
        [ 'PP', 'P', 'M', 'G', '36', '38', '40', '42', '44', 'Único' ].shuffle.each do |size|
          FactoryGirl.create(:catalog_product,
                             catalog: @collection_theme.catalog,
                             category_id: Category::CLOTH,
                             cloth_size: size)
        end
      end

      it { should eql([ 'PP', 'P', 'M', 'G', '36', '38', '40', '42', '44', 'Único' ])}
    end
  end
end
