require 'spec_helper'

describe FullLook::LookBuilder do
  describe ".perform" do
    it "should instantiate self and call perform" do
      new_look_builder = mock('LookBuilder')
      described_class.should_receive(:new).and_return(new_look_builder)
      new_look_builder.should_receive(:perform)
      described_class.perform
    end
  end

  it "should have a @queue variable in the singleton" do
    expect( described_class.instance_variable_get('@queue') ).to_not be_nil
  end

  describe '#perform' do
    def product(id, attrs={})
      mock("Product##{id}",
           full_look_picture: attrs.keys.include?(:full_look_picture) ? attrs[:full_look_picture] : mock("Picture##{id}", image_url: "image#{id}"),
           front_picture: attrs.keys.include?(:front_picture) ? attrs[:front_picture] : mock("Picture##{id}", image_url: "image#{id}"),
           launch_date: "2013-12-25",
           brand: attrs[:brand] || 'Olook',
           inventory: attrs[:inventory] || 10,
           is_visible: attrs[:is_visible].nil? ? true : attrs[:is_visible])
    end

    before do
      subject.stub!(:set_category_weight_factor).and_return(Hash.new(1))
      FullLook::LookProfileCalculator.stub(:calculate).and_return(1)
      Look.stub!(:build_and_create)
    end
    it "should create 2 Looks" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(3))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(4))
      relateds << mock('RelatedProduct', product_a_id: 5, product_a: product(5), product_b: product(6))
      relateds << mock('RelatedProduct', product_a_id: 5, product_a: product(5), product_b: product(7))
      subject.stub(:related_products).and_return(relateds)
      Look.should_receive(:build_and_create).exactly(2).times
      subject.perform
    end

    it "create with correct params" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(3))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(4))
      subject.stub(:related_products).and_return(relateds)
      Look.should_receive(:build_and_create).with({product_id: 1, full_look_picture: "image1", front_picture: "image1", launched_at: "2013-12-25", profile_id: 1})
      subject.perform
    end

    it "send related products to look profile calculator" do
      product_1 = product(1)
      product_2 = product(2)
      product_3 = product(3)
      product_4 = product(4)
      FullLook::LookProfileCalculator.should_receive(:calculate).with([product_1],category_weight: subject.category_weight).and_return(1)
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product_1, product_b: product_2)
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product_1, product_b: product_3)
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product_1, product_b: product_4)
      subject.stub(:related_products).and_return(relateds)
      subject.perform
    end

    it "should filter out looks with less than 2 products" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(3))
      relateds << mock('RelatedProduct', product_a_id: 5, product_a: product(5), product_b: product(6))
      subject.stub(:related_products).and_return(relateds)
      Look.should_receive(:build_and_create).exactly(2).times
      subject.perform
    end

    it "should filter out looks with products that not belongs to Olook brand" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, brand: 'olook concept'), product_b: product(2, brand: 'Colcci'))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, brand: 'olook concept'), product_b: product(3))
      subject.stub(:related_products).and_return(relateds)
      Look.should_not_receive(:build_and_create)
      subject.perform
    end

    it "should filter out looks with master_product brand that not belongs to Olook" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, brand: 'colcci'), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, brand: 'colcci'), product_b: product(3))
      subject.stub(:related_products).and_return(relateds)
      Look.should_not_receive(:build_and_create)
      subject.perform
    end

    it "should filter out looks with master_product zero inventory" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, inventory: 0), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, inventory: 0), product_b: product(3))
      subject.stub(:related_products).and_return(relateds)
      Look.should_not_receive(:build_and_create)
      subject.perform
    end

    it "should filter out looks with related products with zero inventory" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(2, inventory: 0))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(3))
      subject.stub(:related_products).and_return(relateds)
      Look.should_not_receive(:build_and_create)
      subject.perform
    end

    it "should filter out looks with master_product invisible" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, is_visible: false), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, is_visible: false), product_b: product(3))
      subject.stub(:related_products).and_return(relateds)
      Look.should_not_receive(:build_and_create)
      subject.perform
    end

    it "should filter out looks with related products invisible" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(2, is_visible: false))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(3))
      subject.stub(:related_products).and_return(relateds)
      Look.should_not_receive(:build_and_create)
      subject.perform
    end

    it "should filter out looks without full_look_picture" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, full_look_picture: nil), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, full_look_picture: nil), product_b: product(3))
      subject.stub(:related_products).and_return(relateds)
      Look.should_not_receive(:build_and_create)
      subject.perform
    end

    it "should filter out looks without front_picture" do
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, front_picture: nil), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1, front_picture: nil), product_b: product(3))
      subject.stub(:related_products).and_return(relateds)
      Look.should_not_receive(:build_and_create)
      subject.perform
    end
  end
end

