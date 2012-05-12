require "spec_helper"

describe CatalogSearchService do
  let(:catalog) do
    moment  = Factory.create :moment
    moment.catalog
  end
  
  let(:basic_bag) do
    product = (Factory.create :bag_subcategory_name).product
    
    Factory.create :basic_bag_simple, product: product

    product
  end

  let(:basic_accessory) do
    product = (Factory.create :bag_subcategory_name).product
    
    Factory.create :basic_bag_simple, product: product

    product
  end

  let(:basic_shoe) do
    product = (Factory.create :shoe_subcategory_name).product
    Factory.create :shoe_heel, :product => product
    Factory.create :basic_shoe_size_35, :product => product, :inventory => 7
    product.master_variant.price = 100.00
    product.master_variant.save!
    product
  end

  let(:basic_shoe_2) do
    product = (Factory.create :shoe_subcategory_name, description: "Melissa").product
    product.master_variant.price = 100.00
    product.master_variant.save!
    Factory.create :basic_shoe_size_40, :product => product, :inventory => 8
    product
  end

  let(:basic_shoe_3) do
    product = (Factory.create :shoe_subcategory_name, description: "Bota").product
    product.master_variant.price = 100.00
    product.master_variant.save!
    Factory.create :basic_shoe_size_37, :product => product, :inventory => 5
    product
  end
  
  let(:basic_bag_1) { FactoryGirl.create(:basic_bag_simple, product: basic_bag) }
  let(:basic_accessory_1) { FactoryGirl.create(:basic_accessory_simple, product: basic_accessory) }

  before :each do
    # LiquidationProduct.delete_all
    Product.delete_all
    Variant.delete_all
    Catalog::Product.delete_all
  end

  describe "#search_products" do
    context "isolated filters" do
      it "returns products given only a catalog" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first

        params = {id: catalog.id}
        CatalogSearchService.new(params).search_products.should == [cp1, cp2, cp3]
      end

      it "returns products given some subcategories" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first

        params = {id: catalog.id, shoe_subcategories: ["Sandalia"]}
        CatalogSearchService.new(params).search_products.should == [cp1]
      end

      it "returns products given some shoe sizes" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first

        params = {:id => catalog.id, :shoe_sizes => ["40", "35"]}
        CatalogSearchService.new(params).search_products.should == [cp1, cp2]
      end

      it "returns products given some shoe sizes" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first

        params = {:id => catalog.id, :heels => ["0-5-cm"]}
        CatalogSearchService.new(params).search_products.should == [cp1]
      end

    #    it "returns products given some heels" do
    #      lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :heel => 4.5, :inventory => 1)
    #      lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :heel => 6.5, :inventory => 1)
    #      lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :subcategory_name => "melissa", :inventory => 1)
    #      params = {:id => catalog.id, :heels => ["6.5", "4.5"]}
    #      CatalogSearchService.new(params).search_products.should == [lp1, lp2]
    #    end

    #    it "returns 0 products if dont have inventory" do
    #      lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :heel => 4.5, :inventory => 0)
    #      params = {:id => catalog.id, :heels => ["6.5", "4.5"]}
    #      CatalogSearchService.new(params).search_products.should == []
    #    end

    #    it "returns 0 products if the product is not visible" do
    #      basic_shoe_size_35.product.update_attributes(:is_visible => false)
    #      lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :heel => 4.5, :inventory => 1)
    #      params = {:id => catalog.id, :heels => ["6.5", "4.5"]}
    #      CatalogSearchService.new(params).search_products.should == []
    #    end
    #  end

    #  context "ordering" do
    #   it "should return the order: shoes, bags and acessories" do
    #     lp1 = LiquidationProduct.create(:category_id => Category::SHOE, :liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :heel => 4.5, :inventory => 1)
    #     lp2 = LiquidationProduct.create(:category_id => Category::ACCESSORY, :liquidation => liquidation, :product_id => basic_accessory_1.product.id, :subcategory_name => "pulseira", :inventory => 1)
    #     lp3 = LiquidationProduct.create(:category_id => Category::BAG, :liquidation => liquidation, :product_id => basic_bag_1.product.id, :subcategory_name => "lisa", :inventory => 1)
    #     params = {:id => catalog.id, :bag_accessory_subcategories => ["pulseira", "lisa"], :heels => ["4.5"]}
    #     CatalogSearchService.new(params).search_products.should == [lp1, lp3, lp2]
    #   end
    # end

    # context "combined filters" do
    #   it "returns products given subcategories, shoe sizes and heels" do
    #     lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "45", :heel => "5.6")
    #     lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "45", :heel => "5.6")
    #     params = {:id => catalog.id, :shoe_subcategories => ["rasteirinha"], :shoe_sizes => ["45"], :heels => ["5.6"]}
    #     CatalogSearchService.new(params).search_products.should == [lp1, lp2]
    #   end

    #   it "returns products given subcategories and shoe sizes" do
    #     lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "45")
    #     lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "45")
    #     lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "39")
    #     params = {:id => catalog.id, :shoe_subcategories => ["rasteirinha"], :shoe_sizes => ["45"]}
    #     CatalogSearchService.new(params).search_products.should == [lp1, lp2]
    #   end

    #   it "returns products given subcategories and heels" do
    #     lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :heel => "5.6")
    #     lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :heel => "5.9")
    #     params = {:id => catalog.id, :shoe_subcategories => ["rasteirinha"], :heels => ["5.6", "5.9"]}
    #     CatalogSearchService.new(params).search_products.should == [lp1, lp2]
    #   end

    #   it "returns products given heels and shoe sizes" do
    #     lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "37", :heel => "5.6")
    #     lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :subcategory_name => "melissa", :inventory => 1, :shoe_size => "37", :heel => "7.6")
    #     lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "melissa", :inventory => 1, :shoe_size => "37", :heel => "5.6")
    #     params = {:id => catalog.id, :shoe_subcategories => ["melissa", "rasteirinha"], :shoe_sizes => ["37"], :heels => ["5.6"]}
    #     CatalogSearchService.new(params).search_products.should == [lp1, lp3]
    #   end

    #   it "returns products given heels and shoe sizes and bags" do
    #     lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "37", :heel => "5.6")
    #     lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :subcategory_name => "melissa", :inventory => 1, :shoe_size => "37", :heel => "7.6")
    #     lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "melissa", :inventory => 1, :shoe_size => "37", :heel => "5.6")
    #     lp4 = LiquidationProduct.create(:category_id => Category::BAG, :liquidation => liquidation, :product_id => basic_bag_1.product.id, :subcategory_name => "lisa", :inventory => 1)
    #     params = {:id => catalog.id, :bag_accessory_subcategories => ["lisa"], :shoe_subcategories => ["melissa", "rasteirinha"], :shoe_sizes => ["37"], :heels => ["5.6"]}
    #     CatalogSearchService.new(params).search_products.should == [lp1, lp3, lp4]
    #   end

    #   it "returns products given heels and shoe sizes and bags and acessories" do
    #     lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "37", :heel => "5.6")
    #     lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :subcategory_name => "melissa", :inventory => 1, :shoe_size => "37", :heel => "7.6")
    #     lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "melissa", :inventory => 1, :shoe_size => "37", :heel => "5.6")
    #     lp4 = LiquidationProduct.create(:category_id => Category::BAG, :liquidation => liquidation, :product_id => basic_bag_1.product.id, :subcategory_name => "lisa", :inventory => 1)
    #     lp5 = LiquidationProduct.create(:category_id => Category::ACCESSORY, :liquidation => liquidation, :product_id => basic_accessory_1.product.id, :subcategory_name => "pulseira", :inventory => 1)
    #     params = {:id => catalog.id, :bag_accessory_subcategories => ["lisa", "pulseira"], :shoe_subcategories => ["melissa", "rasteirinha"], :shoe_sizes => ["37"], :heels => ["5.6"]}
    #     CatalogSearchService.new(params).search_products.should == [lp1, lp3, lp4, lp5]
    #   end

    #   it "returns products given heels and shoe sizes and bags, acessories and not invisible items" do
    #     lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha", :inventory => 1, :shoe_size => "37", :heel => "5.6")
    #     lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :subcategory_name => "melissa", :inventory => 1, :shoe_size => "37", :heel => "7.6")
    #     lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "melissa", :inventory => 1, :shoe_size => "37", :heel => "5.6")
    #     lp4 = LiquidationProduct.create(:category_id => Category::BAG, :liquidation => liquidation, :product_id => basic_bag_1.product.id, :subcategory_name => "lisa", :inventory => 1)

    #     basic_accessory_1.product.update_attributes(:is_visible => false)

    #     lp5 = LiquidationProduct.create(:category_id => Category::ACCESSORY, :liquidation => liquidation, :product_id => basic_accessory_1.product.id, :subcategory_name => "pulseira", :inventory => 1)
    #     params = {:id => catalog.id, :bag_accessory_subcategories => ["lisa", "pulseira"], :shoe_subcategories => ["melissa", "rasteirinha"], :shoe_sizes => ["37"], :heels => ["5.6"]}
    #     CatalogSearchService.new(params).search_products.should == [lp1, lp3, lp4]
    #   end
    end
  end
end
