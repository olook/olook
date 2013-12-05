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
end
