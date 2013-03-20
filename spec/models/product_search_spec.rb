describe ProductSearch do
  describe ".terms_for" do
    let!(:product) { FactoryGirl.create(:basic_shoe) }

    it "Redis receives zrevrange method " do
      Redis.any_instance.should_receive(:zrevrange)
      described_class.terms_for("Foo")
    end
  end
end
