require 'spec_helper'

describe Gift::SuggestionsController do

  let!(:recipient) { FactoryGirl.create(:gift_recipient) }
  let!(:occasion) { FactoryGirl.create(:gift_occasion, :gift_recipient => recipient) }
  let!(:product) { FactoryGirl.create(:basic_bag) }

  describe "GET 'index'" do
    before do
      session[:occasion_id] = occasion.id
      ProductFinderService.stub_chain(:new, :suggested_products_for)
      ProductFinderService.stub_chain(:new, :showroom_products)
    end

    context "gift_recipient" do
      it "finds gift recipient" do
        GiftRecipient.should_receive(:find).with("123").and_return(recipient)
        get 'index', :recipient_id => "123"
      end

      it "assigns @gift_recipient to the recipient found" do
        get 'index', :recipient_id => recipient.id.to_s
        assigns(:gift_recipient).should == recipient
      end
    end

    context "occasion" do
      before do
        GiftRecipient.stub(:find).with("123").and_return(recipient)
      end

      it "gets the occasions from the gift recipient" do
        occasions = [ occasion ]
        recipient.should_receive(:gift_occasions).and_return(occasions)
        get 'index', :recipient_id => "123"
      end

      it "assigns @occasion to the last occasion" do
        occasions = double(:occcasions)
        recipient.stub(:gift_occasions).and_return(occasions)
        occasions.should_receive(:last).and_return(occasion)

        get 'index', :recipient_id => "123"
        assigns(:occasion).should == occasion
      end
    end

    context "suggested products" do
      let(:product_finder_service) { mock }

      it "assigns @suggested_products as a list of suggested products" do
        product_finder_service.stub(:showroom_products)
        ProductFinderService.should_receive(:new).with(recipient).and_return(product_finder_service)
        product_finder_service.should_receive(:suggested_products_for).
          with(recipient.profile, recipient.shoe_size).and_return(:suggested_products)
        get 'index', :recipient_id => recipient.id
        assigns(:suggested_products).should == :suggested_products
      end

      it "assigns @products" do
        product_finder_service.stub(:suggested_products_for)
        ProductFinderService.should_receive(:new).with(recipient).and_return(product_finder_service)
        product_finder_service.should_receive(:showroom_products).with(:description => recipient.shoe_size).and_return(:showroom_products)
        get 'index', :recipient_id => recipient.id
        assigns(:products).should == :showroom_products
      end
    end
  end

  context "GET 'select_gift'" do
    it "finds product with product id" do
      Product.should_receive(:find).with("123").and_return(product)
      xhr :get, 'select_gift', :product_id => "123"
    end

    it "assigns @product to the product found" do
      xhr :get, 'select_gift', :product_id => product.id
      assigns(:product).should == product
   end
  end
end
