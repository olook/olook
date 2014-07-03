require 'spec_helper'

describe Gift::SuggestionsController do

  let!(:recipient) { FactoryGirl.create(:gift_recipient) }
  let!(:occasion) { FactoryGirl.create(:gift_occasion, :gift_recipient => recipient) }
  let!(:product) do
    product = (FactoryGirl.create :bag_subcategory_name).product
    product.master_variant.price = 100.00
    product.master_variant.save!

    FactoryGirl.create :basic_bag_simple, :product => product

    product
  end

  describe "GET 'index'" do
    before do
      session[:occasion_id] = occasion.id
      ProductFinderService.stub_chain(:new, :suggested_variants_for)
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

      it "sets recipiend_id in the session with the gift_recipient id" do
        get 'index', :recipient_id => recipient.id.to_s
        session[:recipient_id].should == recipient.id
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

      it "assigns @suggested_variants_for as a list of suggested products" do
        product_finder_service.stub(:showroom_products)
        ProductFinderService.should_receive(:new).with(recipient).and_return(product_finder_service)
        product_finder_service.should_receive(:suggested_variants_for).
          with(recipient.profile, recipient.shoe_size).and_return(:suggested_variants)
        get 'index', :recipient_id => recipient.id
        assigns(:suggested_variants).should == :suggested_variants
      end

      it "assigns @products" do
        product_finder_service.stub(:suggested_variants_for)
        ProductFinderService.should_receive(:new).with(recipient).and_return(product_finder_service)
        product_finder_service.should_receive(:showroom_products).with(:description => recipient.shoe_size, :not_allow_sold_out_products => true).and_return(:showroom_products)
        get 'index', :recipient_id => recipient.id
        assigns(:products).should == :showroom_products
      end
    end
  end

  context "GET 'select_gift'" do
    it "assigns @variant when product_id is send" do
      xhr :get, 'select_gift', :product_id => product.id, :recipient_id => recipient.id
      assigns(:variant).should == product.variants.last
   end
  end
end
