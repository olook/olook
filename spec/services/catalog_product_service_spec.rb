require 'spec_helper'

describe CatalogProductService do
  let(:catalog) do
    moment  = Factory.create :moment
    moment.catalog
  end
  
  let(:basic_bag) do
    product = (Factory.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!
    
    Factory.create :basic_bag_simple, :product => product

    product
  end

  let(:basic_shoes) do
    
    product = (Factory.create :shoe_subcategory_name).product
    
    Factory.create :shoe_heel, :product => product
    Factory.create :basic_shoe_size_35, :product => product, :inventory => 7
    Factory.create :basic_shoe_size_37, :product => product, :inventory => 5
    
    product.master_variant.price = 100.00
    product.master_variant.save!

    product
  end

  it "should calculate the retail price based on the discount percent" do
    product = mock Product
    product.stub(:price).and_return 100.90
    CatalogProductService.new(catalog, product, :discount_percentage => 50).retail_price.should == BigDecimal("50.45")
  end

  describe "insert a product" do
    it "should insert without discount for bag product" do
      expect {
         ct_product = CatalogProductService.new(catalog, basic_bag).save!         
         
         ct_product.catalog_id.should       eq catalog.id
         ct_product.product_id.should       eq basic_bag.id
         ct_product.category_id.should      eq basic_bag.category
         ct_product.subcategory_name.should eq "bolsa-azul"
         ct_product.original_price.should   eq 100.0
         ct_product.retail_price.should     eq 100.0
         ct_product.discount_percent.should eq 0
         ct_product.shoe_size.should        be_nil
         ct_product.heel.should             be_nil
         ct_product.variant_id.should       eq basic_bag.variants.first.id
         ct_product.inventory.should        eq 10
         ct_product.shoe_size_label.should  be_nil
         ct_product.heel_label.should       be_nil
         ct_product.subcategory_name_label.should eq "Bolsa Azul"
      }.to change(catalog.products, :count).by(1)
    end
    
    it "should insert with discount" do
      expect {
         ct_product = CatalogProductService.new(catalog, basic_bag, :discount_percentage => 50).save!         
         
         ct_product.catalog_id.should         eq catalog.id
         ct_product.product_id.should         eq basic_bag.id
         ct_product.category_id.should        eq basic_bag.category
         ct_product.subcategory_name.should   eq "bolsa-azul"
         ct_product.original_price.should     eq 100.0
         ct_product.retail_price.should       eq 50.0
         ct_product.discount_percent.should   eq 50
         ct_product.shoe_size.should          be_nil
         ct_product.heel.should               be_nil
         ct_product.variant_id.should         eq basic_bag.variants.first.id
         ct_product.inventory.should          eq 10
         ct_product.shoe_size_label.should    be_nil
         ct_product.heel_label.should         be_nil
         ct_product.subcategory_name_label.should eq "Bolsa Azul"
      }.to change(catalog.products, :count).by(1)
    end
    
    it "should insert one row per variant of shoe" do
      expect {
        ct_products = CatalogProductService.new(catalog, basic_shoes).save!         
        
        ct_products[0].catalog_id.should        eq catalog.id
        ct_products[0].product_id.should        eq basic_shoes.id
        ct_products[0].category_id.should       eq basic_shoes.category
        ct_products[0].subcategory_name.should  eq "sandalia"
        ct_products[0].original_price.should    eq 100.0
        ct_products[0].retail_price.should      eq 100.0
        ct_products[0].discount_percent.should  eq 0
        ct_products[0].shoe_size.should         eq 35
        ct_products[0].heel.should              eq "0-5-cm"
        ct_products[0].variant_id.should        eq basic_shoes.variants[0].id
        ct_products[0].inventory.should         eq 7
        ct_products[0].shoe_size_label.should   eq '35'
        ct_products[0].heel_label.should        eq "0,5 cm"
        ct_products[0].subcategory_name_label.should eq "Sandalia"
        
        ct_products[1].catalog_id.should        eq catalog.id
        ct_products[1].product_id.should        eq basic_shoes.id
        ct_products[1].category_id.should       eq basic_shoes.category
        ct_products[1].subcategory_name.should  eq "sandalia"
        ct_products[1].original_price.should    eq 100.0
        ct_products[1].retail_price.should      eq 100.0
        ct_products[1].discount_percent.should  eq 0
        ct_products[1].shoe_size.should         eq 37
        ct_products[1].heel.should              eq "0-5-cm"
        ct_products[1].variant_id.should        eq basic_shoes.variants[1].id
        ct_products[1].inventory.should         eq 5
        ct_products[1].shoe_size_label.should   eq '37'
        ct_products[1].heel_label.should        eq "0,5 cm"
        ct_products[1].subcategory_name_label.should eq "Sandalia"
      }.to change(catalog.products, :count).by(2)
    end
  end


  describe "update a product" do
    it "should update info" do
      ct_product = CatalogProductService.new(catalog, basic_bag).save!
      ct_product_id = ct_product.id
      
      detail_subcategory = basic_bag.details.where(:translation_token => Product::SUBCATEGORY_TOKEN).first
      detail_subcategory.update_attributes!(:description => "Nova Categoria")
      
      basic_bag.master_variant.update_attributes!(:price => 50.00)
      basic_bag.variants.first.update_attributes!(:inventory => 5)

      ct_product = CatalogProductService.new(catalog, basic_bag, :discount_percentage => 50).save!
      ct_product.id.should               eq ct_product_id
      ct_product.subcategory_name.should eq "nova-categoria"
      ct_product.original_price.should   eq 100.0
      ct_product.retail_price.should     eq 100.0
      ct_product.discount_percent.should eq 0
      ct_product.shoe_size.should        be_nil
      ct_product.heel.should             be_nil
      ct_product.variant_id.should       eq basic_bag.variants.first.id
      ct_product.inventory.should        eq 5
      ct_product.shoe_size_label.should  be_nil
      ct_product.heel_label.should       be_nil
      ct_product.subcategory_name_label.should eq "Nova Categoria"
    end
    
    it "should update info one row per variant of shoe" do
      ct_products = CatalogProductService.new(catalog, basic_shoes).save!         
      ct_products_id = [ct_products[0].id, ct_products[1].id]
      
      detail_subcategory = basic_shoes.details.where(:translation_token => Product::SUBCATEGORY_TOKEN).first
      detail_subcategory.update_attributes!(:description => "Nova Categoria")
      
      basic_shoes.master_variant.update_attributes!(:price => 50.00)
      basic_shoes.variants.first.update_attributes!(:inventory => 5)
      basic_shoes.variants.last.update_attributes!(:inventory => 2)

      ct_products = CatalogProductService.new(catalog, basic_shoes, :discount_percentage => 50).save!
      
      ct_products[0].id.should                eq ct_products_id[0]
      ct_products[0].subcategory_name.should  eq "nova-categoria"
      ct_products[0].original_price.should    eq 100.0
      ct_products[0].retail_price.should      eq 100.0
      ct_products[0].discount_percent.should  eq 0
      ct_products[0].shoe_size.should         eq 35
      ct_products[0].heel.should              eq "0-5-cm"
      ct_products[0].variant_id.should        eq basic_shoes.variants[0].id
      ct_products[0].inventory.should         eq 5
      ct_products[0].shoe_size_label.should   eq '35'
      ct_products[0].heel_label.should        eq "0,5 cm"
      ct_products[0].subcategory_name_label.should eq "Nova Categoria"
      
      ct_products[1].id.should               eq ct_products_id[1]
      ct_products[1].subcategory_name.should eq "nova-categoria"
      ct_products[1].original_price.should   eq 100.0
      ct_products[1].retail_price.should     eq 100.0
      ct_products[1].discount_percent.should  eq 0
      ct_products[1].shoe_size.should         eq 37
      ct_products[1].heel.should              eq "0-5-cm"
      ct_products[1].variant_id.should        eq basic_shoes.variants[1].id
      ct_products[1].inventory.should         eq 2
      ct_products[1].shoe_size_label.should   eq '37'
      ct_products[1].heel_label.should        eq "0,5 cm"
      ct_products[1].subcategory_name_label.should eq "Nova Categoria"
    end
    
    describe "when update price" do
      it "should update for product" do
        ct_product = CatalogProductService.new(catalog, basic_bag).save!
        ct_product_id = ct_product.id

        detail_subcategory = basic_bag.details.where(:translation_token => Product::SUBCATEGORY_TOKEN).first
        detail_subcategory.update_attributes!(:description => "Nova Categoria")

        basic_bag.master_variant.update_attributes!(:price => 50.00)
        basic_bag.variants.first.update_attributes!(:inventory => 5)

        ct_product = CatalogProductService.new(catalog, basic_bag, :discount_percentage => 50, :update_price => true).save!
        ct_product.id.should               eq ct_product_id
        ct_product.subcategory_name.should eq "nova-categoria"
        ct_product.original_price.should   eq 50.0
        ct_product.retail_price.should     eq 25.0
        ct_product.discount_percent.should eq 50
        ct_product.shoe_size.should        be_nil
        ct_product.heel.should             be_nil
        ct_product.variant_id.should       eq basic_bag.variants.first.id
        ct_product.inventory.should        eq 5
        ct_product.shoe_size_label.should  be_nil
        ct_product.heel_label.should       be_nil
        ct_product.subcategory_name_label.should eq "Nova Categoria"
      end

      it "should update one row per variant of shoe" do
        ct_products = CatalogProductService.new(catalog, basic_shoes).save!         
        ct_products_id = [ct_products[0].id, ct_products[1].id]

        detail_subcategory = basic_shoes.details.where(:translation_token => Product::SUBCATEGORY_TOKEN).first
        detail_subcategory.update_attributes!(:description => "Nova Categoria")

        basic_shoes.master_variant.update_attributes!(:price => 50.00)
        basic_shoes.variants.first.update_attributes!(:inventory => 5)
        basic_shoes.variants.last.update_attributes!(:inventory => 2)

        ct_products = CatalogProductService.new(catalog, basic_shoes, :discount_percentage => 50, :update_price => true).save!

        ct_products[0].id.should                eq ct_products_id[0]
        ct_products[0].subcategory_name.should  eq "nova-categoria"
        ct_products[0].original_price.should    eq 50.0
        ct_products[0].retail_price.should      eq 25.0
        ct_products[0].discount_percent.should  eq 50
        ct_products[0].shoe_size.should         eq 35
        ct_products[0].heel.should              eq "0-5-cm"
        ct_products[0].variant_id.should        eq basic_shoes.variants[0].id
        ct_products[0].inventory.should         eq 5
        ct_products[0].shoe_size_label.should   eq '35'
        ct_products[0].heel_label.should        eq "0,5 cm"
        ct_products[0].subcategory_name_label.should eq "Nova Categoria"

        ct_products[1].id.should               eq ct_products_id[1]
        ct_products[1].subcategory_name.should eq "nova-categoria"
        ct_products[1].original_price.should   eq 50.0
        ct_products[1].retail_price.should     eq 25.0
        ct_products[1].discount_percent.should  eq 50
        ct_products[1].shoe_size.should         eq 37
        ct_products[1].heel.should              eq "0-5-cm"
        ct_products[1].variant_id.should        eq basic_shoes.variants[1].id
        ct_products[1].inventory.should         eq 2
        ct_products[1].shoe_size_label.should   eq '37'
        ct_products[1].heel_label.should        eq "0,5 cm"
        ct_products[1].subcategory_name_label.should eq "Nova Categoria"
      end
    end
  end
end
