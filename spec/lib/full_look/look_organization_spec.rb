describe FullLook::LookOrganization do

  before do
    @shoe = mock("Product", category: 1)
    @bag = mock("Product", category: 2)
    @accessory = mock("Product", category: 3)
    @cloth = mock("Product", category: 4)
    # @look1 = mock("Look", product: basic_profile)
    # @initialize_array = []
  end
  context "When there is looks with all categories" do
    before do
      1.upto(6) { |i| instance_variable_set("@look#{i}", mock("Look", product: @shoe))}
      7.upto(12) { |i| instance_variable_set("@look#{i}", mock("Look", product: @bag))}
      13.upto(18) { |i| instance_variable_set("@look#{i}", mock("Look", product: @bag))}
    end
    it "returns intercalated categories" do
      puts @look1
      puts @look6
    end
  end
end
