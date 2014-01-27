describe Recommended::OrganizedProducts do

  before do
    1.upto(6) { |i| instance_variable_set("@product#{i}", mock("Product#{i}", category: 1))}
    7.upto(12) { |i| instance_variable_set("@product#{i}", mock("Product#{i}", category: 2))}
    13.upto(18) { |i| instance_variable_set("@product#{i}", mock("Product#{i}", category: 3))}
  end
  context "when there is products from all categories" do
    it "return intercalated products" do
      products = (1..18).map{|a| instance_variable_get("@product#{a}")}
      expect(described_class.organize(products)).to eql([@product1,@product7,@product13])
    end
  end
end
