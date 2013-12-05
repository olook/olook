describe Freebie do
  describe '#can_receive_freebie?' do
    context 'when cart subtotal is bigger than 200' do
      before do
        @init_attrs = { subtotal: 201 }
      end
      subject { Freebie.new(@init_attrs).can_receive_freebie? }
      it { should be }
    end

    context 'when cart subtotal is less than 200' do
      before do
        @init_attrs = { subtotal: 101 }
      end
      subject { Freebie.new(@init_attrs).can_receive_freebie? }
      it { should_not be }
    end
  end

  describe '.product_is_freebie?' do
    context 'when product_id is 23035' do
      subject { Freebie.product_is_freebie?(23035) }
      it { should be }
    end

    context 'when product_id is 23034' do
      subject { Freebie.product_is_freebie?(23034) }
      it { should_not be }
    end
  end
end
