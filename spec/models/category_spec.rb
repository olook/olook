require "spec_helper"

describe Category do
  it "should return an array with all category types" do
    Category.list_of_all_categories.should == [Category::SHOE, Category::BAG, Category::ACCESSORY]
  end
end
