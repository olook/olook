require File.expand_path(File.join(File.dirname(__FILE__), '../../../lib/full_look/look_builder'))

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
    describe "#normalize_products" do
      before  do
        mock('RelatedProduct',product_a: 1, product_b: [2,3] )
      end
      it "return hash with master_product and products" do
        subject.should_receive(:products).and_return(@related_products)
        expect(subject.normalize_products).to eql {}
      end
    end
  end
end

