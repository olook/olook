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
    def product(id)
      mock("Product##{id}",
           gallery_5_pictures: [mock(image_url: 'image')],
           launch_date: Time.now)
    end

    before do
      subject.stub!(:set_category_weight_factor).and_return(Hash.new(1))
      relateds = []
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(2))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(3))
      relateds << mock('RelatedProduct', product_a_id: 1, product_a: product(1), product_b: product(4))
      relateds << mock('RelatedProduct', product_a_id: 5, product_a: product(5), product_b: product(6))
      relateds << mock('RelatedProduct', product_a_id: 5, product_a: product(5), product_b: product(7))
      subject.should_receive(:related_products).and_return(relateds)
    end

    it "should create 2 Looks" do
      Look.should_receive(:build_and_create).exactly(2).times
      subject.perform
    end
  end
end

