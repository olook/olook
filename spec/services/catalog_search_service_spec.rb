require "spec_helper"

describe CatalogSearchService do
  let(:catalog) do
    collection_theme  = FactoryGirl.create :collection_theme
    collection_theme.catalog
  end

  let(:basic_bag) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    FactoryGirl.create :basic_bag_simple, product: product
    product
  end

  let(:basic_accessory) do
    product = (FactoryGirl.create :accessory_subcategory_name).product
    FactoryGirl.create :basic_accessory_simple, product: product
    product
  end

  let(:basic_shoe) do
    product = (FactoryGirl.create :shoe_subcategory_name).product
    FactoryGirl.create :shoe_heel, :product => product
    FactoryGirl.create :basic_shoe_size_35, :product => product, :inventory => 7
    product.master_variant.price = 100.00
    product.master_variant.save!
    product
  end

  let(:basic_shoe_2) do
    product = (FactoryGirl.create :shoe_subcategory_name, description: "Melissa").product
    FactoryGirl.create :shoe_heel, :product => product, :description => "Alto"
    FactoryGirl.create :basic_shoe_size_40, :product => product, :inventory => 8
    product.master_variant.price = 10.00
    product.master_variant.save!
    product
  end

  let(:basic_shoe_3) do
    product = (FactoryGirl.create :shoe_subcategory_name, description: "Bota").product
    FactoryGirl.create :basic_shoe_size_37, :product => product, :inventory => 5
    product.master_variant.price = 50.00
    product.master_variant.save!
    product
  end

  let(:basic_shoe_4) do
    product = (FactoryGirl.create :shoe_subcategory_name, description: "Bota").product
    FactoryGirl.create :basic_shoe_size_37, :product => product, :inventory => 5
    product.master_variant.price = 10.00
    product.master_variant.save!
    product
  end

  let(:basic_shoe_5) do
    product = (FactoryGirl.create :shoe_subcategory_name, description: "Bota").product
    FactoryGirl.create :basic_shoe_size_37, :product => product, :inventory => 5
    product.master_variant.price = 30.00
    product.master_variant.save!
    product
  end

  let(:sold_out_shoe) do
    product = (FactoryGirl.create :shoe_subcategory_name, description: "Galocha").product
    FactoryGirl.create :basic_shoe_size_37, :product => product, :inventory => 0
    product.master_variant.price = 50.00
    product.master_variant.save!
    product
  end

  let(:hidden_shoe) do
    product = (FactoryGirl.create :shoe_subcategory_name, description: "Invisivel").product
    FactoryGirl.create :basic_shoe_size_37, :product => product, :inventory => 1
    product.master_variant.price = 50.00
    product.master_variant.save!
    product.update_attributes! is_visible: false
    product
  end

  let(:liquidation) { FactoryGirl.create(:liquidation) }

  before :each do
    Liquidation.delete_all
    LiquidationProduct.delete_all
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
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should include(cp2)
        products.should include(cp3)
      end

      it "returns products given some subcategories" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first

        params = {id: catalog.id, shoe_subcategories: ["Sandalia"]}
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should_not include(cp2)
        products.should_not include(cp3)
      end

      it "returns products given some shoe sizes and subcategory" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first

        params = {:id => catalog.id, shoe_subcategories: ["Sandalia"], :shoe_sizes => ["40", "35"]}
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should_not include(cp2)
        products.should_not include(cp3)
      end

      it "returns products given some heels" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first

        params = {:id => catalog.id, :heels => ["0-5-cm"]}
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should_not include(cp2)
        products.should_not include(cp3)
      end

       it "returns 0 products if dont have inventory" do
        cp1 = CatalogProductService.new(catalog, sold_out_shoe).save!.first
        params = {:id => catalog.id}
        CatalogSearchService.new(params).search_products.should == []
       end

       it "returns 0 products if the product is not visible" do
        cp1 = CatalogProductService.new(catalog, hidden_shoe).save!.first
        params = {:id => catalog.id}
        CatalogSearchService.new(params).search_products.should == []
       end
     end

    context "ordering" do
      it "should return the order: shoes, bags and acessories" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_accessory).save!
        cp3 = CatalogProductService.new(catalog, basic_bag).save!
        params = {:id => catalog.id}
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should include(cp2)
        products.should include(cp3)
      end
    end

    context "combined filters" do
      it "returns products given subcategories, shoe sizes and heels" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first
        params = {:id => catalog.id, :shoe_subcategories => ["Sandalia","Melissa"], :shoe_sizes => ["35","40"], :heels => ["0-5-cm","alto"]}
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should include(cp2)
        products.should_not include(cp3)
      end

      it "returns products given subcategories, shoe sizes and heels and bags" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first
        cp4 = CatalogProductService.new(catalog, basic_bag).save!
        params = {:id => catalog.id, :shoe_subcategories => ["Sandalia","Melissa"], :shoe_sizes => ["35","40"], :heels => ["0-5-cm","alto"], :bag_subcategories => ["bolsa-azul"]}
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should include(cp2)
        products.should include(cp4)
        products.should_not include(cp3)
      end

      it "returns products given subcategories, heels and shoe sizes and bags and acessories" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first
        cp4 = CatalogProductService.new(catalog, basic_bag).save!
        cp5 = CatalogProductService.new(catalog, basic_accessory).save!
        params = {:id => catalog.id, :shoe_subcategories => ["Sandalia","Melissa"], :shoe_sizes => ["35","40"], :heels => ["0-5-cm","alto"], :bag_subcategories => ["bolsa-azul"], :accessory_subcategories => ["colar"]}
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should include(cp2)
        products.should include(cp4)
        products.should include(cp5)
        products.should_not include(cp3)
      end
    end

    context "price range" do
      it "returns values greater than the floor value" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first
        params = {price: "20-*", id: catalog.id}
        products = CatalogSearchService.new(params).search_products
        products.should include(cp1)
        products.should_not include(cp2)
        products.should include(cp3)
      end
      it "returns values lower than the ceil value" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first
        params = {price: "*-90", id: catalog.id}
        products = CatalogSearchService.new(params).search_products
        products.should_not include(cp1)
        products.should include(cp2)
        products.should include(cp3)
      end
      it "returns values between the floor and ceil value" do
        cp1 = CatalogProductService.new(catalog, basic_shoe).save!.first
        cp2 = CatalogProductService.new(catalog, basic_shoe_2).save!.first
        cp3 = CatalogProductService.new(catalog, basic_shoe_3).save!.first
        params = {price: "40-90", id: catalog.id}
        products = CatalogSearchService.new(params).search_products
        products.should_not include(cp1)
        products.should_not include(cp2)
        products.should include(cp3)
      end
    end

    context "filtering by brand" do
      before do
        basic_shoe.update_attributes(brand: "Some brand")
        basic_bag.update_attributes({brand: "Some brand", price: 50})
        basic_accessory.update_attributes({brand: "Other Brand", price: 50})

        @first_product = CatalogProductService.new(catalog, basic_shoe.reload).save!.first
        @third_product = CatalogProductService.new(catalog, basic_accessory.reload).save!
        @second_product = CatalogProductService.new(catalog, basic_bag).save!
      end

      context "when 'Some Brand' and 'Other Brand' are selected" do

        before do
          params = {:id => catalog.id, brands: ["Some brand", "Other Brand"]}
          @products = CatalogSearchService.new(params).search_products
        end
        it { expect(@products.first).to eq(@first_product) }
        it { expect(@products.second).to eq(@second_product) }
        it { expect(@products.third).to eq(@third_product) }
      end

      context "when 'Other Brand' is selected" do
        before do
          params = {:id => catalog.id, brands: ["Other Brand"]}
          @products = CatalogSearchService.new(params).search_products
        end        
        it { expect(@products.first).to eq(@third_product) }
      end
    end
  end
end
