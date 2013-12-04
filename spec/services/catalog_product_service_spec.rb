require 'spec_helper'

describe CatalogProductService do
  let(:catalog) do
    collection_theme  = FactoryGirl.create :collection_theme
    collection_theme.catalog
  end

  let(:basic_bag) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!

    FactoryGirl.create :basic_bag_simple, :product => product

    product.reload
  end

  let(:basic_bag_with_discount) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.retail_price = 85.00
    product.master_variant.save!

    FactoryGirl.create :basic_bag_simple, :product => product

    product.reload
  end


  let(:basic_shoes) do
    product = (FactoryGirl.create :shoe_subcategory_name).product

    FactoryGirl.create :shoe_heel, :product => product
    FactoryGirl.create :basic_shoe_size_35, :product => product, :inventory => 7
    FactoryGirl.create :basic_shoe_size_37, :product => product, :inventory => 5

    product.master_variant.price = 100.00
    product.master_variant.save!

    product.reload
  end

  let(:basic_shirt) do
    product = (FactoryGirl.create :garment_subcategory_name).product

    product.master_variant.price = 100.00
    product.master_variant.save!

    FactoryGirl.create :yellow_shirt, :product => product

    product.reload
  end

  describe "#save!" do

    context "insert a product" do
      it "should insert bag without any discount" do
        expect {
          ct_product = CatalogProductService.new(catalog, basic_bag).save!

          ct_product.catalog_id.should       eq catalog.id
          ct_product.product_id.should       eq basic_bag.id
          ct_product.category_id.should      eq basic_bag.category
          ct_product.subcategory_name.should eq "bolsa-azul"
          ct_product.original_price.should   eq 100.0
          ct_product.retail_price.should     eq 100.0
          ct_product.shoe_size.should        be_nil
          ct_product.heel.should             be_nil
          ct_product.variant_id.should       eq basic_bag.variants.first.id
          ct_product.inventory.should        eq 10
          ct_product.shoe_size_label.should  be_nil
          ct_product.heel_label.should       be_nil
          ct_product.subcategory_name_label.should eq "Bolsa Azul"
        }.to change(catalog.products, :count).by(1)
      end

      it "should insert bag with discount by master_variant" do
        expect {
          ct_product = CatalogProductService.new(catalog, basic_bag_with_discount).save!

          ct_product.catalog_id.should         eq catalog.id
          ct_product.product_id.should         eq basic_bag_with_discount.id
          ct_product.category_id.should        eq basic_bag_with_discount.category
          ct_product.subcategory_name.should   eq "bolsa-azul"
          ct_product.original_price.should     eq 100.0
          ct_product.retail_price.should       eq 85.0
          ct_product.shoe_size.should          be_nil
          ct_product.heel.should               be_nil
          ct_product.variant_id.should         eq basic_bag_with_discount.variants.first.id
          ct_product.inventory.should          eq 10
          ct_product.shoe_size_label.should    be_nil
          ct_product.heel_label.should         be_nil
          ct_product.subcategory_name_label.should eq "Bolsa Azul"
        }.to change(catalog.products, :count).by(1)
      end

      it "should insert bag with discount by service" do
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

      it "should insert shirt without discount" do
        expect {
          ct_product = CatalogProductService.new(catalog, basic_shirt).save!

          ct_product[0].catalog_id.should         eq catalog.id
          ct_product[0].product_id.should         eq basic_shirt.id
          ct_product[0].category_id.should        eq basic_shirt.category
          ct_product[0].subcategory_name.should   eq "camiseta-amarela"
          ct_product[0].original_price.should     eq 100.0
          ct_product[0].retail_price.should       eq 100.0
          ct_product[0].shoe_size.should          be_nil
          ct_product[0].heel.should               be_nil
          ct_product[0].variant_id.should         eq basic_shirt.variants.first.id
          ct_product[0].inventory.should          eq 10
          ct_product[0].shoe_size_label.should    be_nil
          ct_product[0].heel_label.should         be_nil
          ct_product[0].subcategory_name_label.should eq "Camiseta Amarela"
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


    context "update a product" do
      it "should update info" do
        ct_product = CatalogProductService.new(catalog, basic_bag).save!
        ct_product_id = ct_product.id

        detail_subcategory = basic_bag.details.where(:translation_token => Product::SUBCATEGORY_TOKEN).first
        detail_subcategory.update_attributes!(:description => "Nova Categoria")

        basic_bag.master_variant.update_attributes!(:price => 50.00)
        basic_bag.variants.first.update_attributes!(:inventory => 5)

        basic_bag.reload

        ct_product = CatalogProductService.new(catalog, basic_bag, :discount_percentage => 50).save!
        ct_product.id.should               eq ct_product_id
        ct_product.subcategory_name.should eq "nova-categoria"
        ct_product.original_price.should   eq 100.0
        ct_product.retail_price.should     eq 100.0
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

        basic_shoes.reload

        ct_products = CatalogProductService.new(catalog, basic_shoes, :discount_percentage => 50).save!

        ct_products[0].id.should                eq ct_products_id[0]
        ct_products[0].subcategory_name.should  eq "nova-categoria"
        ct_products[0].original_price.should    eq 100.0
        ct_products[0].retail_price.should      eq 100.0
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
        ct_products[1].shoe_size.should         eq 37
        ct_products[1].heel.should              eq "0-5-cm"
        ct_products[1].variant_id.should        eq basic_shoes.variants[1].id
        ct_products[1].inventory.should         eq 2
        ct_products[1].shoe_size_label.should   eq '37'
        ct_products[1].heel_label.should        eq "0,5 cm"
        ct_products[1].subcategory_name_label.should eq "Nova Categoria"
      end

      context "when update price" do
        it "should update for product" do
          ct_product = CatalogProductService.new(catalog, basic_bag).save!
          ct_product_id = ct_product.id

          detail_subcategory = basic_bag.details.where(:translation_token => Product::SUBCATEGORY_TOKEN).first
          detail_subcategory.update_attributes!(:description => "Nova Categoria")

          basic_bag.master_variant.update_attributes!(:price => 50.00)
          basic_bag.variants.first.update_attributes!(:inventory => 5)

          basic_bag.reload

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

        it "should update for product garment" do
          ct_product = CatalogProductService.new(catalog, basic_shirt).save![0]
          ct_product_id = ct_product.id

          detail_subcategory = basic_shirt.details.where(:translation_token => Product::SUBCATEGORY_TOKEN).first
          detail_subcategory.update_attributes!(:description => "Nova Categoria")

          basic_shirt.master_variant.update_attributes!(:price => 50.00)
          basic_shirt.variants.first.update_attributes!(:inventory => 5)

          basic_shirt.reload

          ct_product = CatalogProductService.new(catalog, basic_shirt, :discount_percentage => 50, :update_price => true).save![0]
          ct_product.id.should               eq ct_product_id
          ct_product.subcategory_name.should eq "nova-categoria"
          ct_product.original_price.should   eq 50.0
          ct_product.retail_price.should     eq 25.0
          ct_product.discount_percent.should eq 50
          ct_product.shoe_size.should        be_nil
          ct_product.heel.should             be_nil
          ct_product.variant_id.should       eq basic_shirt.variants.first.id
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
          basic_shoes.reload

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

  describe "destroy" do
    it "should destroy a bag" do
      ct_product = CatalogProductService.new(catalog, basic_bag)
      ct_product.save!
      expect {
        ct_product.destroy
      }.to change{catalog.products.count}.by(-1)
    end
    it "should destroy a shoe and its variants" do
      ct_product = CatalogProductService.new(catalog, basic_shoes)
      ct_product.save!
      expect {
        ct_product.destroy
      }.to change{catalog.products.count}.by(-2)
    end
  end
end
