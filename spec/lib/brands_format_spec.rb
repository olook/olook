describe BrandsFormat do
  before do
    @default_brands = ["284", "AFGHAN", "AGUA DOCE", "OLLI", "OLOOK ESSENTIAL", "Olook Concept", "olook"]
  end

  it "return array of brands split by four" do
    BrandsFormat.any_instance.stub(:get_sort_brands_from_cache).and_return(@default_brands)
    expect(subject.retrieve_brands).to eql([[["0-9",["284"]]],[["A",["AFGHAN","AGUA DOCE"]]],[["O",["OLLI","OLOOK ESSENTIAL","Olook Concept","olook"]]]])
  end
end
