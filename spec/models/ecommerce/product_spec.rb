# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Product do
  describe "validation" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:model_number) }

    it { should respond_to :backside_picture }
    it { should respond_to :wearing_picture }
    it { should respond_to :remove_freebie }
  end

  describe "associations" do
    it { should have_and_belong_to_many(:collection_themes) }
    it { should have_many(:pictures) }
    it { should have_many(:details) }
    it { should have_many(:variants) }
    it { should have_many(:catalog_products) }
    it { should have_many(:catalogs) }
    it { should have_many(:consolidated_sells) }
    it { should have_many(:price_logs) }
    it { should belong_to(:collection) }
    it { should have_and_belong_to_many(:profiles) }
  end

  describe 'callbacks' do
    describe 'before_save' do

      describe 'when the product is set to visible' do
        let(:product) { FactoryGirl.build(:shoe, :invisible_shoe) }
        let(:visible_product) { FactoryGirl.build(:shoe) }

        context 'at the first time' do
          it 'its lanuch date is set to current date' do
            expect(product.is_visible).to be_false
            product.is_visible = true
            product.save!
            expect(product.launch_date).to eq(Time.zone.now.to_date)
          end
        end

        context 'at a second time' do
          before do
            @old_launch_date = 10.days.ago.to_date
            visible_product.update_attribute(:launch_date, @old_launch_date)
          end

          it 'keeps the last launch date' do
            visible_product.is_visible = false
            visible_product.save!
            visible_product.is_visible = true
            visible_product.save!
            expect(visible_product.is_visible).to be_true
            expect(visible_product.launch_date).to eq(@old_launch_date)
          end
        end


      end

    end
  end

  describe 'scopes' do
    describe ".with_brand" do
      let!(:product_with_given_brand) { FactoryGirl.create(:shoe, :casual, brand: "Some Brand") }
      let!(:product_without_given_brand) { FactoryGirl.create(:shoe, :casual, brand: "Other Brand") }

      subject { described_class.with_brand("Some Brand") }

      it { should include product_with_given_brand }
      it { should_not include product_without_given_brand }
    end

    describe ".with_visibility" do
      let(:visible_product) { FactoryGirl.create(:shoe, :casual, is_visible: true) }
      let(:invisible_product) { FactoryGirl.create(:shoe, :casual, is_visible: false) }

      context "when looking for visible products" do
        subject { described_class.with_visibility(1) }

        it { should include visible_product }
        it { should_not include invisible_product }
      end

      context "when looking for invisible products" do
        subject { described_class.with_visibility(0) }

        it { should include invisible_product }
        it { should_not include visible_product }
      end
    end

    describe "'.by_inventory" do
      let!(:product_in_stock) { FactoryGirl.create(:shoe_variant, :in_stock).product }
      let!(:product_sold_out) { FactoryGirl.create(:shoe_variant, :sold_out).product }
      context "when order is decreasing" do
        subject { described_class.by_inventory("desc") }
        it { should eq([product_in_stock, product_sold_out]) }
      end

      context "when order is ascendant" do
        subject { described_class.by_inventory("asc") }
        it { should eq([product_sold_out, product_in_stock]) }
      end
    end

    describe "'.by_sold" do
      let!(:product_with_more_orders) { FactoryGirl.create(:shoe_variant, :in_stock, initial_inventory: 20, inventory: 1).product }
      let!(:product_with_less_orders) { FactoryGirl.create(:shoe_variant, :in_stock, initial_inventory: 20, inventory: 10).product }
      context "when order is decreasing" do
        subject { described_class.by_sold("desc") }
        it { should eq([product_with_more_orders, product_with_less_orders]) }
      end

      context "when order is ascendant" do
        subject { described_class.by_sold("asc") }
        it { should eq([product_with_less_orders, product_with_more_orders]) }
      end
    end

  end

  describe "#already_sold" do
    let(:product) { described_class.new }
    before do
      product.stub(:initial_inventory).and_return(9)
      product.stub(:inventory).and_return(3)
    end

    subject { product.quantity_alredy_sold }

    it { should eq(6) }
  end

  describe "#add_freebie" do
    let(:product) { FactoryGirl.create :blue_sliper_with_variants }
    let(:bag) { FactoryGirl.create(:basic_bag_with_variant) }
    let(:shoe) { FactoryGirl.create(:shoe, :casual) }

    it { should respond_to :add_freebie }

    context "when adding a bag" do
      it "every variant should have a freebie" do
        FreebieVariant.should_receive(:create!).exactly(product.variants.size).times
        product.add_freebie bag
      end
    end

  end

  describe "scopes" do
    let!(:shoe)      { FactoryGirl.create(:shoe, :casual) }
    let!(:shoe_for_xml) { FactoryGirl.create :blue_sliper_with_variants }
    let!(:bag)       { FactoryGirl.create(:basic_bag) }
    let!(:accessory) { FactoryGirl.create(:basic_accessory) }
    let!(:invisible_shoe) { FactoryGirl.create(:shoe, :casual, :is_visible => false) }

    context ".shoes" do
      it "includes all shoes" do
        shoes = [shoe, invisible_shoe]
        (described_class.shoes & shoes).should == shoes
      end

      it "does not include other kinds of items" do
        other = [bag, accessory]
        (described_class.shoes & other).should be_empty
      end
    end

    context ".bags" do
      it "includes a bag" do
        described_class.bags.should include bag
      end

      it "does not include other kinds of items" do
        other = [shoe, invisible_shoe, accessory]
        (described_class.bags & other).should be_empty
      end
    end

    context ".acessories" do
      it "includes an accessory" do
        described_class.accessories.should include accessory
      end

      it "does not include other kinds of items" do
        other = [shoe, invisible_shoe, bag]
        (described_class.accessories & other).should be_empty
      end
    end

    context ".visible" do
      it "returns visible products" do
        visible_products = [shoe, bag, accessory]
        (described_class.only_visible & visible_products) =~ visible_products
      end

      it "does not return a invisible product" do
        described_class.accessories.should_not include invisible_shoe
      end
    end

    context "xml ouput" do

      describe ".valid_for_xml" do
        it "returns shoes with variants and doesn't return shoes without variants" do
          shoe_for_xml.master_variant.update_attribute(:price, 1.0)
          #about the factories: shoe_for_xml includes variants, shoe doesn't
          described_class.valid_for_xml("0").should include(shoe_for_xml)
          described_class.valid_for_xml("0").should_not include(shoe)
        end

        it "doesn't return shoes with less than 3 variants with 3 inventory each" do
          # leave only 3 variants on factory
          shoe_for_xml.variants.first.destroy
          # set inventory to less than 3 on each variant
          shoe_for_xml.variants.each {|v| v.update_attribute(:inventory, 2)}
          described_class.valid_for_xml("0").should_not include(shoe_for_xml)
        end

        it "returns shoes with 3 or more variants with 3 or more inventory each" do
          # leave only 3 variants on factory
          shoe_for_xml.master_variant.update_attribute(:price, 1.0)
          shoe_for_xml.variants.each {|v| v.update_attribute(:inventory, 4)}
          described_class.valid_for_xml("0").should include(shoe_for_xml)
        end

        context "when product is a cloth and" do
          let!(:collection) { FactoryGirl.create(:collection) }
          let!(:cloth_with_all_sizes) { FactoryGirl.create(:simple_garment, collection: collection) }
          let!(:variant1) { FactoryGirl.create(:yellow_shirt, product: cloth_with_all_sizes, is_master: false, description: "35") }
          let!(:variant2) { FactoryGirl.create(:yellow_shirt, product: cloth_with_all_sizes, is_master: false, description: "36") }
          let!(:cloth_without_one_size) { FactoryGirl.create(:simple_garment, collection: collection) }
          let!(:variant_sold_out) { FactoryGirl.create(:yellow_shirt, inventory: 0, product: cloth_without_one_size, is_master: false, description: "40") }
          let!(:avalaible) { FactoryGirl.create(:yellow_shirt, product: cloth_without_one_size, is_master: false, description: "40") }
          subject { described_class.valid_for_xml("0") }

          context "when cloth has no variants with invetory eq 0" do
            it { expect(subject).to include cloth_with_all_sizes }
          end

          context "when cloth has any variant with inventory eq 0" do
            it { expect(subject).to_not include cloth_without_one_size }
          end

        end
      end

      describe "blacklisted products" do
        before do
          shoe.master_variant.update_attribute(:price, 1.0)
        end
      end
    end
  end

  describe 'when working with related products' do
    subject { FactoryGirl.create(:red_slipper) }
    let(:silver_slipper) { FactoryGirl.create(:silver_slipper) }
    let(:shoe) { FactoryGirl.create(:shoe) }
    let(:unrelated_product) { FactoryGirl.create(:shoe, :casual) }

    it "#related_products" do
      FactoryGirl.create(:related_product, :product_a => subject, :product_b => silver_slipper )
      subject.related_products.should include(silver_slipper)
    end

    it "#unrelated_products" do
      related_product = FactoryGirl.create(:related_product, :product_a => silver_slipper, :product_b => subject)
      subject.unrelated_products.should include unrelated_product
      subject.unrelated_products.should_not include related_product
    end

    describe "#is_related_to?" do
      before :each do
        FactoryGirl.create(:related_product, :product_a => subject, :product_b => silver_slipper )
      end

      it "should return true when the relationship exists" do
        subject.is_related_to?(silver_slipper).should be_true
      end
      it "should return false when the relationship doesn't exists" do
        subject.is_related_to?(subject).should be_false
      end
    end

    it "#relate_with_product" do
      subject.relate_with_product(silver_slipper)
      subject.related_products.should include(silver_slipper)
    end
  end

  describe "#master_variant" do
    subject { FactoryGirl.build(:shoe, :casual) }

    it "newly initialized products should return nil" do
      subject.master_variant.should be_nil
    end

    it "should call create_master_variant after_saving a new product" do
      subject.should_receive(:create_master_variant)
      subject.save
    end

    it "should call update_master_variant after_saving a change in the product" do
      subject.save
      subject.price = 10
      subject.should_receive(:update_master_variant)
      subject.save
    end

    it "should be created automaticaly after the product is created" do
      subject.save
      subject.master_variant.should_not be_nil
      subject.master_variant.should be_persisted
      subject.master_variant.description.should == 'master'
    end

    describe 'helper methods' do
      it '#create_master_variant' do
        new_variant = double :variant
        new_variant.should_receive(:'save!')
        Variant.should_receive(:new).and_return(new_variant)
        subject.instance_variable_get('@master_variant').should be_nil
        subject.send :create_master_variant
        subject.instance_variable_get('@master_variant').should == new_variant
      end

      describe '#update_master_variant' do
        before :each do
          subject.save # create product
          subject.description = 'a'
        end

        it 'should trigger the method after_update' do
          subject.should_receive(:update_master_variant)
          subject.save
        end

        it 'should call save on the master variant' do
          subject.master_variant.should_receive(:'save!')
          subject.save
        end

        it 'fix bug: should not break if @master_variant was not initialized' do
          loaded_product = Product.find subject.id
          expect {
            loaded_product.save
          }.not_to raise_error
        end
      end
    end
  end

  describe "picture helpers" do
    let(:mock_picture) { double :picture }

    describe '#main_picture' do
      let!(:some_picture) { FactoryGirl.create(:picture, :product => subject, :display_on => DisplayPictureOn::GALLERY_3) }
      let!(:main_picture) { FactoryGirl.create(:main_picture, :product => subject) }

      it 'should return the picture to be displayed as Gallery 1' do
        subject.main_picture.should == main_picture
      end
    end

    describe "#showroom_picture" do
      it "should return the showroom sized image if it exists" do
        mock_picture.stub(:image_url).with(:showroom).and_return(:valid_image)
        subject.stub(:main_picture).and_return(mock_picture)
        subject.showroom_picture.should == :valid_image
      end
      it "should return nil if it doesn't exist" do
        subject.showroom_picture.should be_nil
      end
    end

    describe '#thumb_picture' do
      it "should return the thumb sized image if it exists" do
        mock_picture.stub(:image_url).with(:thumb).and_return(:valid_image)
        subject.stub(:main_picture).and_return(mock_picture)
        subject.thumb_picture.should == :valid_image
      end
      it "should return nil if it doesn't exist" do
        subject.thumb_picture.should be_nil
      end
    end

    describe '#catalog_picture' do
      it "should return the picture sized image if it exists" do
        mock_picture.stub(:image_url).with(:catalog).and_return(:valid_image)
        mock_picture.stub(:display_on).and_return(1)
        subject.stub(:main_picture).and_return(mock_picture)
        subject.catalog_picture.should == :valid_image
      end
      it "should return nil if it doesn't exist" do
        subject.catalog_picture.should be_nil
      end
    end

    describe '#return_catalog_or_suggestion_image' do
      context "when product has picture" do
        it "returns catalog picture" do
          mock_picture.stub(:image_url).with(:catalog).and_return(:valid_image)
          mock_picture.stub(:display_on).and_return(1)
          subject.stub(:main_picture).and_return(mock_picture)
          subject.return_catalog_or_suggestion_image(mock_picture).should eq(:valid_image)
        end
      end

      context "when product has no picture" do
        it "returns nil" do
          mock_picture = nil
          subject.return_catalog_or_suggestion_image(mock_picture).should be_nil
        end
      end
    end

    describe '#image_at_position' do
      let!(:shoe)      { FactoryGirl.create(:shoe, :casual) }
      let!(:main_picture)      { FactoryGirl.create(:main_picture) }
      it 'should return the image at asked position' do
        shoe.pictures << main_picture

        picture = shoe.picture_at_position 1
        picture.should eq main_picture
      end

      it 'should return nil if there is no picture at desired position' do
        picture = shoe.picture_at_position 1
        picture.should be nil
      end

    end
  end

  describe "#product_color" do
    let(:product) {FactoryGirl.create(:shoe, :casual) }
    let(:product_with_details) {FactoryGirl.create(:shoe, :casual) }
    let!(:detail_supplier) {FactoryGirl.create(:supplier_color_detail, product: product_with_details)}
    let!(:detail_product) {FactoryGirl.create(:product_color_detail, product: product_with_details)}
    let!(:detail_filter) {FactoryGirl.create(:filter_color_detail, product: product_with_details)}

    context "when details exist" do
      it "Show filter color" do
        expect(product_with_details.filter_color).to eql("Blue")
      end
      it "Show product color" do
        expect(product_with_details.product_color).to eql("Dark Blue")
      end
      it "Show supplier color" do
        expect(product_with_details.supplier_color).to eql("Blue")
      end
    end

    context "when details dont exist" do
      it "Show filter color" do
        expect(product.filter_color).to eql("Não informado")
      end
      it "Show product color" do
        expect(product.product_color).to eql("Black")
      end
      it "Show supplier color" do
        expect(product.supplier_color).to eql("Não informado")
      end
    end
  end

  describe '#variants.sorted_by_description' do
    subject { FactoryGirl.create(:shoe, :casual) }
    let!(:last_variant) { FactoryGirl.create(:variant, :product => subject, :description => '36') }
    let!(:first_variant) { FactoryGirl.create(:variant, :product => subject, :description => '35') }

    it 'should return the variants sorted by description' do
      subject.variants.should == [last_variant, first_variant]
      subject.variants.sorted_by_description.should == [first_variant, last_variant]
    end
  end

  describe "#colors" do
    let(:black_shoe) { FactoryGirl.create(:shoe, :casual, :color_name => 'black', :color_sample => 'black_sample', name: "A1B2C3") }
    let!(:blue_shoe) { FactoryGirl.create(:shoe, :casual, :color_name => 'blue', :color_sample => 'blue_sample', name: "A1B2C3" ) }
    let(:red_shoe) { FactoryGirl.create(:shoe, :casual, :color_name => 'red', :color_sample => 'red_sample', name: "A1B2C3" ) }
    let(:other_shoe) { FactoryGirl.create(:shoe, :casual, :color_name => 'red', :color_sample => 'red_sample', name: "4D5E6F" ) }

    subject { black_shoe.colors }

    describe "color variations" do
      context "when product has other products with the same producer_code" do
        it "returns other products with the same producer_code" do
          should include red_shoe
          should include blue_shoe
        end
        it "doesn't return product with a different producer_code" do
          should_not include other_shoe
        end
        it "exludes the current product" do
          should_not include black_shoe
        end
      end
    end

    describe "ordering by variant inventory" do
      let!(:variant) { FactoryGirl.create(:variant, inventory: 5, product: blue_shoe, description: "37") }
      let!(:variant_with_more_inventory) { FactoryGirl.create(:variant, inventory: 10, product: red_shoe, description: "38") }
      let!(:variant_with_less_inventory) { FactoryGirl.create(:variant, inventory: 1, product: blue_shoe, description: "39") }

      context "without shoe size given" do
        it "retuns products with variants ordered by desc inventory" do
          should eq([red_shoe, blue_shoe])
        end
      end

      context "with shoe size given" do

        subject { black_shoe.colors("37") }

        it "returns products with user's shoe size first and others products last" do
          should eq([blue_shoe, red_shoe])
        end

      end
      describe "products visibility" do
        let(:invisible_product) { FactoryGirl.create(:shoe, is_visible: false, name: "A1B2C3") }
        context "when given user is admin" do
          subject { black_shoe.colors("", true) }
          it "returns all products including invisible" do
            should include invisible_product
          end

        end

        context "when given user is not admin" do
          subject { black_shoe.colors }
          it "returns only visible products" do
            should_not include invisible_product
          end
        end
      end
    end

    describe "#all_colors" do
      it "returns a list of related products of the same category including the current product and orderd by product id" do
        #black_shoe.all_colors.should == [black_shoe, red_shoe]
      end
    end
  end

  describe "#easy_to_find_description" do
    subject { FactoryGirl.build(:basic_bag,
                                :model_number => 'M123',
                                :name         => 'Fake product',
                                :color_name   => 'Black') }

    it 'should return a string with the model_number, name, color and humanized category' do
      subject.easy_to_find_description.should == 'M123 - Fake product - Black - Bolsa'
    end
  end

  describe 'inventory related methods' do
    subject { FactoryGirl.create(:shoe, :casual) }
    let!(:basic_shoe_size_35) { FactoryGirl.create :basic_shoe_size_35, :product => subject }
    let!(:basic_shoe_size_40) { FactoryGirl.create :basic_shoe_size_40, :product => subject }

    describe '#inventory' do
      it "should return the sum of the variants inventory" do
        basic_shoe_size_35.update_attributes(:inventory => 3)
        basic_shoe_size_40.update_attributes(:inventory => 1)
        subject.inventory.should == 4
      end
    end

    describe '#sold_out?' do
      it "should return false if any of the variants is available" do
        subject.stub(:inventory).and_return(2)
        subject.should_not be_sold_out
      end
      it "should return true if none of the variants is available" do
        subject.stub(:inventory).and_return(0)
        subject.should be_sold_out
      end
    end
  end

  describe '#product_url' do
    subject { FactoryGirl.create(:shoe, :casual) }

    context "without params" do
      it "returns valid url with the product id" do
        subject.product_url.should == "http://www.olook.com.br/produto/#{subject.id}?utm_content=#{subject.id}&utm_medium=vitrine"
      end
    end

    context "with params" do
      it "returns valid url with the product id" do
        subject.product_url(:utm_source => "criteo", :utm_campaign => "teste").should == "http://www.olook.com.br/produto/#{subject.id}?utm_campaign=teste&utm_content=#{subject.id}&utm_medium=vitrine&utm_source=criteo"
      end
    end

  end

  describe "#instock" do
    it "returns 1 when product is in stock" do
      subject.stub(:inventory).and_return(1)
      subject.instock.should == "1"
    end

    it "returns 0 when product is not in stock" do
      subject.stub(:inventory).and_return(0)
      subject.instock.should == "0"
    end
  end

  describe "#gift_price" do
    it "calls GiftDiscountService passing the product, the position and returns it" do
      GiftDiscountService.should_receive(:price_for_product).with(subject,1).and_return(69.90)
      subject.gift_price(1).should == 69.90
    end
  end

  describe "#subcategory" do
    it "gets the subcategory from the product details" do
      subject.should_receive(:subcategory_name).and_return("Pulseira")
      subject.subcategory.should == "Pulseira"
    end
  end

  describe "#promotion?" do
    it "return false when price is same of retail price" do
      subject.stub(:price => 123.45)
      subject.stub(:retail_price => 123.45)
      subject.promotion?.should be_false
    end

    it "return true when price has difference of retail price" do
      subject.stub(:price => 123.45)
      subject.stub(:retail_price => 100.45)
      subject.promotion?.should be_true
    end
  end

  describe "#share_by_email" do
    context "when has one email to send" do
      informations = { name_from: "User name", email_from: "user@email.com", emails_to_deliver: "user_friend@email.com" }
       it "receives share mailer deliver" do
         ShareProductMailer.should_receive(:send_share_message_for).with(subject, informations, informations[:emails_to_deliver].split(/,|;|\r|\t/).map(&:strip).first)
         subject.share_by_email(informations)
       end
    end
    context "when has N emails to send" do
      informations = { name_from: "User name", email_from: "user@email.com", emails_to_deliver: "user_friend@email.com, another_friend@email.com, third_fiend@email.com" }
       it "receives share mailer deliver 3 times" do
         ShareProductMailer.should_receive(:send_share_message_for).with(subject, informations, informations[:emails_to_deliver].split(/,|;|\r|\t/).map(&:strip).first)

         ShareProductMailer.should_receive(:send_share_message_for).with(subject, informations, informations[:emails_to_deliver].split(/,|;|\r|\t/).map(&:strip).second)

         ShareProductMailer.should_receive(:send_share_message_for).with(subject, informations, informations[:emails_to_deliver].split(/,|;|\r|\t/).map(&:strip).third)

         subject.share_by_email(informations)
       end
    end
  end

  describe "#shoe_inventory_has_less_than_minimum?" do
    let(:shoe_for_xml) { FactoryGirl.create :blue_sliper_with_variants }

    context "shoe with less than 3 variants" do
      it "returns true" do
        # leave only 2 variants on factory
        shoe_for_xml.variants.first(2).each {|v| v.destroy}
        shoe_for_xml.shoe_inventory_has_less_than_minimum?.should be_true
      end
    end

    context "shoe with 3 or more  variants" do

      context "but with less than 3 inventory in any of them" do
        it "returns true" do
          # set inventory to less than 3 on each variant
          shoe_for_xml.variants.each {|v| v.update_attribute(:inventory, 2)}
          shoe_for_xml.shoe_inventory_has_less_than_minimum?.should be_true
        end
      end

      context "with 3 or more inventory each" do
        it "returns false" do
          shoe_for_xml.shoe_inventory_has_less_than_minimum?.should be_false
        end
      end
    end

    context "products that aren't shoes" do
      let(:basic_bag_for_xml) { FactoryGirl.create(:basic_bag) }

      it "returns false" do
        basic_bag_for_xml.shoe_inventory_has_less_than_minimum?.should be_false
      end
    end

  end

  describe 'find_suggested_products' do
    context "when product has suggested products" do
      let!(:first_shoe) { FactoryGirl.create(:shoe, name: "234") }
      let!(:second_shoe) { FactoryGirl.create(:red_slipper, collection_id: 1, name: "234a") }
      let!(:third_shoe) { FactoryGirl.create(:silver_slipper, collection_id: 1, name: "234b") }
      let!(:subcategory) { FactoryGirl.create(:shoe_subcategory_name, product: second_shoe) }
      let!(:another_subcategory) { FactoryGirl.create(:shoe_subcategory_name, product: third_shoe) }

      before do
        first_shoe.stub(:subcategory).and_return("Scarpin")
        second_shoe.stub(:subcategory).and_return("Sandalia")
        third_shoe.stub(:subcategory).and_return("Sandalia")
        subject.stub(:subcategory).and_return("Sandalia")
        subject.stub(:collection_id).and_return(1)
      end

      it { subject.find_suggested_products.should_not include (first_shoe) }
      it { subject.find_suggested_products.should include (second_shoe) }
      it { subject.find_suggested_products.should include (third_shoe) }

    end
  end

  describe "#item_view_cache_key_for" do
    context "when product is shoe" do
      subject { FactoryGirl.build(:shoe, id: 10) }
      context "and has shoe_size 37" do
        it { expect(subject.item_view_cache_key_for("37")).to eq(CACHE_KEYS[:product_item_partial_shoe][:key] % [subject.id, 37]) }
      end

      context "and has no shoe_size" do
        it { expect(subject.item_view_cache_key_for).to eq(CACHE_KEYS[:product_item_partial_shoe][:key] % [subject.id, nil]) }
      end
    end

    context "when product is not a shoe" do
      subject { FactoryGirl.build(:bag, id: 10) }
      it { expect(subject.item_view_cache_key_for).to eq(CACHE_KEYS[:product_item_partial][:key] % subject.id) }
    end
  end

  describe "#delete_cache" do
    context "when product is a shoe" do
      subject { FactoryGirl.create(:shoe, :in_stock) }
      it "deletes all product keys cache" do
        subject.variants.collect(&:description).each do |shoe_size|
          Rails.cache.should_receive(:delete).with("views/#{subject.item_view_cache_key_for(shoe_size)}")
          Rails.cache.should_receive(:delete).with("views/#{subject.lite_item_view_cache_key_for(shoe_size)}")
        end
        Rails.cache.should_receive(:delete).with("views/#{subject.item_view_cache_key_for}")
        Rails.cache.should_receive(:delete).with("views/#{subject.lite_item_view_cache_key_for}")
        subject.delete_cache
      end
    end

    context "when product is not a shoe" do
      subject { FactoryGirl.create(:bag) }
      it "deletes all product keys cache" do
        Rails.cache.should_receive(:delete).with("views/#{subject.item_view_cache_key_for}")
        Rails.cache.should_receive(:delete).with("views/#{subject.lite_item_view_cache_key_for}")
        subject.delete_cache
      end
    end
  end

  describe "#is_a_shoe_accessory?" do
    let(:product) { FactoryGirl.build(:product) }
    context "when is a shoe accessory" do
      before do
        product.stub(:subcategory).and_return("Amaciante")
      end
      subject { product.is_a_shoe_accessory? }
      it { should be_true }
    end

    context "when isn't a shoe accessory" do
      before do
        product.stub(:subcategory).and_return("Blusa")
      end
      subject { product.is_a_shoe_accessory? }

      it { should be_false }
    end
  end

  describe "#sort_details_by_relevance" do
    before do
      category_detail = FactoryGirl.build(:shoe_subcategory_name)
      heel_detail = FactoryGirl.build(:shoe_heel)
      shoe_with_leather_detail = FactoryGirl.build(:shoe_with_leather)
      metal_detail = FactoryGirl.build(:shoe_with_metal)
      @details = [ category_detail, metal_detail, heel_detail, shoe_with_leather_detail ]
    end

    context "when there'no any unexpected detail" do
      it { expect(subject.sort_details_by_relevance(@details.shuffle)).to eq(@details) }
    end

    context "when there's any expected detail" do
      before do
        @details << FactoryGirl.build(:detail, translation_token: "Unexpected")
      end
      it { expect(subject.sort_details_by_relevance(@details.shuffle)).to eq(@details) }
    end
  end

  describe "#xml_picture" do
    before do
      subject.stub(:main_picture).and_return('cdn_main_picture_path.png')
      subject.main_picture.stub(:image).and_return('main_picture_path.png')
    end
    context "when product has picture for xml" do
      before do
        subject.picture_for_xml.stub(:main).and_return('main_xml_picture_path.png')
        subject.picture_for_xml.stub(:thumb).and_return('thumb_xml_picture_path.png')
      end
      context "main" do
        it { expect(subject.xml_picture(:main)).to eq("main_xml_picture_path.png") }
      end
      context "thumb" do
        it { expect(subject.xml_picture(:thumb)).to eq("thumb_xml_picture_path.png") }
      end
    end

    context "when product hasn't picture for xml" do
      before do
        subject.picture_for_xml.stub(:main).and_return("")
      end

      it { expect(subject.xml_picture(:main)).to eq("main_picture_path.png") }
    end
  end

  describe '#is_the_size_grid_enough?' do
    subject { product.is_the_size_grid_enough? }
    context "shoe" do
      let(:product) { FactoryGirl.create(:shoe) }
      context "when number of variants with inventory greater than zero is eq 4" do
        before do
          i = 1
          %w[37 38 39 40].each do |size|
            FactoryGirl.create(:variant_without_association, description: size, display_reference: "size-#{ size }", inventory: i, product: product)
            i =+ 1
          end
        end

        it { should be_true }
      end

      context "when number of variants with inventory greater than zero is lower than 4" do
        before do
          variants = []
          i = 0
          %w[37 38 39 40].each do |size|
            variants << FactoryGirl.create(:variant_without_association, description: size, display_reference: "size-#{ size }", inventory: i, product: product)
            i =+ 1
          end
        end

        it { should be_false }
      end
    end

    context "cloth" do
      let(:product) { FactoryGirl.create(:simple_garment) }

      context "when has variant with size M and at least one more size" do
        before do
          FactoryGirl.create(:variant_without_association, description: 'P' , display_reference: 'size-P', product: product, inventory: 10)
          FactoryGirl.create(:variant_without_association, description: 'M' , display_reference: 'size-M', product: product, inventory: 10)
        end

        it { should be_true }
      end

      context "when has only variant with size M" do
        let(:product) { FactoryGirl.create(:simple_garment) }
        before do
          FactoryGirl.create(:variant_without_association, description: 'M' , display_reference: 'size-M', product: product, inventory: 10)
        end

        it { should be_false }
      end

      context "when has variants with sizes 38, 40 and one more size" do
        let(:product) { FactoryGirl.create(:simple_garment) }
        before do
          FactoryGirl.create(:variant_without_association, description: 'P' , display_reference: 'size-P', product: product, inventory: 10)
          FactoryGirl.create(:variant_without_association, description: '38' , display_reference: 'size-38', product: product, inventory: 10)
          FactoryGirl.create(:variant_without_association, description: '40' , display_reference: 'size-40', product: product, inventory: 10)
        end

         it { should be_true }
      end

      context "when has only variants with sizes 38, 40 and at least one more size" do
        before do
          FactoryGirl.create(:variant_without_association, description: '38' , display_reference: 'size-38', product: product, inventory: 10)
          FactoryGirl.create(:variant_without_association, description: '40' , display_reference: 'size-40', product: product, inventory: 10)
        end

         it { should be_false }
      end

      context "when cloth has only one size" do
        before do
          FactoryGirl.create(:variant_without_association, description: 'M' , display_reference: 'size-M', product: product, inventory: 10)
          FactoryGirl.create(:variant_without_association, description: '38' , display_reference: 'size-38', product: product, inventory: 0)
          FactoryGirl.create(:variant_without_association, description: '40' , display_reference: 'size-40', product: product, inventory: 0)
        end

         it { should be_false }
      end
    end

    context "accesory" do
      let(:product) { FactoryGirl.build(:basic_accessory) }
      subject { product.is_the_size_grid_enough? }

      it { should be_true }
    end

    context "bag" do
      let(:product) { FactoryGirl.build(:basic_bag) }
      subject { product.is_the_size_grid_enough? }

      it { should be_true }
    end
  end

  describe 'quantity_sold_per_day_in_last_week' do
    let(:product) { FactoryGirl.create(:shoe) }

    before do
      FactoryGirl.create(:consolidated_sell, day: (Time.zone.today - 1.day), amount: 3, product: product)
      FactoryGirl.create(:consolidated_sell, day: (Time.zone.today - 7.days), amount: 5, product: product)
      FactoryGirl.create(:consolidated_sell, day: (Time.zone.today - 9.days), amount: 15, product: product)
    end

    subject { product.quantity_sold_per_day_in_last_week }

    it { should eq 2 }
  end

  describe '#coverage_of_days_to_sell' do
    before do
      subject.stub(:inventory).and_return(11)
    end
    context "when product was sold in the last week" do
      before do
        subject.stub(:quantity_sold_per_day_in_last_week).and_return(3)
      end

      it { expect(subject.coverage_of_days_to_sell).to eq(4) }
    end

    context "when product was sold in the last week" do
      before do
        subject.stub(:quantity_sold_per_day_in_last_week).and_return(0)
      end

      it { expect(subject.coverage_of_days_to_sell).to eq(180) }
    end
  end

  describe '#time_in_stock' do
    context "when product has integration date" do
      before do
        launch_date = Date.civil(2013, 9, 10)
        @diff = (Date.current - launch_date).to_i
        subject.stub(:launch_date).and_return(launch_date)
      end

      it { expect(subject.time_in_stock).to eq(@diff) }
    end

    context "when product has no integration date" do
      before do
        Timecop.freeze(Time.local(2013, 8, 9))
      end

      after do
        Timecop.return
      end

      it { expect(subject.time_in_stock).to eq(365) }
    end
  end

 describe 'when working with complete look products' do
    subject { FactoryGirl.create(:red_slipper) }
    let(:silver_slipper) { FactoryGirl.create(:silver_slipper, :in_stock) }
    let(:shoe) { FactoryGirl.create(:shoe, :in_stock) }
    let(:unrelated_product) { FactoryGirl.create(:shoe, :casual, :in_stock) }

    describe "#list_contains_all_complete_look_products?" do
      before :each do
        subject.relate_with_product(silver_slipper)
        subject.relate_with_product(shoe)
      end

      context "when list contains all related products" do
        context "when list contains exactly the related products" do
          it "returns true" do
            subject.list_contains_all_complete_look_products?([silver_slipper.id, shoe.id, subject.id]).should be_true
          end
        end
        context "when list contains more ids than the related products" do
          it "returns true" do
            subject.list_contains_all_complete_look_products?([silver_slipper.id, shoe.id, subject.id, unrelated_product.id]).should be_true
          end
        end        
      end

      context "when list doesn't contain all related products" do
        it "returns false" do
          subject.list_contains_all_complete_look_products?([silver_slipper.id, subject.id]).should be_false
        end
      end
    end

    describe "#look_product_ids" do
      it "displays the related product ids + given product id" do
        subject.relate_with_product(silver_slipper)
        subject.relate_with_product(shoe)
        subject.look_product_ids.should eq([silver_slipper.id,shoe.id, subject.id])
      end
    end
  end  
end
