# == Schema Information
#
# Table name: lookbooks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  thumb_image :string(255)
#  active      :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  icon        :string(255)
#  icon_over   :string(255)
#  fg_color    :string(255)
#  bg_color    :string(255)
#  movie_image :string(255)
#

require 'spec_helper'

describe Lookbook do
  let!(:product_a) { FactoryGirl.create(:basic_shoe) }
  let!(:product_b) { FactoryGirl.create(:basic_bag) }
  let!(:product_c) { FactoryGirl.create(:basic_accessory) }


  subject do
    FactoryGirl.create(:complex_lookbook, :product_list => { product_c.id => "1" })
  end

  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should have_many(:images) }
    it { should have_many(:lookbooks_products) }
    it { should have_many(:products) }
    it { should have_one(:video) }
  end

  describe "update lookbook products" do
    before do
      subject.update_attributes(:product_list => { "#{product_a.id}" => "1",  "#{product_b.id}" => "2"},
                                :product_criteo => { "#{product_a.id}" => "1" })
    end

    it "sets product_a and product_b as related products" do
      subject.products.should == [product_a, product_b]
    end

    it "sets product_a and product_b as lookbook products" do
      subject.lookbooks_products.map(&:product_id).should == [product_a.id, product_b.id]
    end

    it "sets product_a in criteo list" do
      subject.lookbooks_products.first.criteo.should eq(true)
    end

  end

end
