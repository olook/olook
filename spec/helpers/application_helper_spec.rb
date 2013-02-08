# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ApplicationHelper do
  describe "#cart_total" do
    it "returns markup for order total" do
     expected = "<span>(<div id=\"cart_items\">0</div>)</span>"
     helper.cart_total(FactoryGirl.create(:clean_cart)).should eq(expected)
    end
  end

  describe "#stylesheet_application" do
    it "returns link to application.css" do
      expected = "<link href=\"/assets/application.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />"
      helper.stylesheet_application.should eq(expected)
    end
  end

  describe "#track_event" do
    it "returns a track event string with category, action and item" do
      helper.track_event('category','action','item').should == "_gaq.push(['_trackEvent', 'category', 'action', 'item']);"
    end

    context "when no item is passed" do
      it "returns a track event with category and action only" do
        helper.track_event('category','action').should == "_gaq.push(['_trackEvent', 'category', 'action', '']);"
      end
    end
  end

  describe "#track_add_to_cart_event" do  
    let(:product_id) { '1' }

    it "returns a track event string with Shopping, AddToCart + referer sufix and product_id" do
      controller.request.stub(:referer).and_return('/member/vitrine')
      helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCartFromVitrine', '1']);"
    end

    context 'when coming from Minha Vitrine' do
      it "returns a track event AddToCartFromVitrine" do
        controller.request.stub(:referer).and_return('/member/vitrine')
        helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCartFromVitrine', '1']);"
      end
    end

    context 'when coming from Tendências' do
      it "returns a track event AddToCartFromTendencias" do
        controller.request.stub(:referer).and_return('/tendencias')
        helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCartFromTendencias', '1']);"
      end
    end

    context 'when coming from Coleções' do
      it "returns a track event AddToCartFromColecoes" do
        controller.request.stub(:referer).and_return('/colecoes')
        helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCartFromColecoes', '1']);"
      end
    end

    context 'when coming from Sapatos' do
      it "returns a track event AddToCartFromBolsas" do
        controller.request.stub(:referer).and_return('/bolsas')
        helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCartFromBolsas', '1']);"
      end
    end

    context 'when coming from Acessórios' do
      it "returns a track event AddToCartFromAcessorios" do
        controller.request.stub(:referer).and_return('/acessorios')
        helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCartFromAcessorios', '1']);"
      end
    end

    context 'when coming from Óculos' do
      it "returns a track event AddToCartFromOculos" do
        controller.request.stub(:referer).and_return('/oculos')
        helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCartFromOculos', '1']);"
      end
    end

    context 'when coming from Stylists' do
      it "returns a track event AddToCartFromStylists" do
        controller.request.stub(:referer).and_return('/stylists')
        helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCartFromStylists', '1']);"
      end
    end

    context 'when no matching referer' do
      it "returns a track event AddToCart with no suffix" do
        controller.request.stub(:referer).and_return('/whatever')
        helper.track_add_to_cart_event(product_id).should == "_gaq.push(['_trackEvent', 'Shopping', 'AddToCart', '1']);"
      end
    end
  end

  describe "#user_avatar" do
    it "return the suer avatar given a type" do
      user = stub(:uid => 123)
      type = "large"
      expected = "https://graph.facebook.com/#{user.uid}/picture?type=#{type}"
      helper.user_avatar(user, type).should == expected
    end
  end

  describe "#member_type" do
    it "checks if user is signed in" do
      helper.should_receive(:'user_signed_in?')
      helper.member_type
    end
    context "when user is not logged in" do
      it "returns visitor" do
        helper.stub(:'user_signed_in?').and_return(false)
        helper.member_type.should == "visitor"
      end
    end

    context "when user is logged in" do
      it "returns member" do
        helper.stub(:'user_signed_in?').and_return(true)
        helper.member_type.should == "member"
      end
    end
  end

  describe "#is_moment_page?" do

    context "when the @featured_products variable is nil" do  
      before do
        @featured_products = nil
      end
      context "when the controller = 'moments' and action = 'show'" do
        before do
          controller.params[:controller] = 'moments'
          controller.params[:action] = 'show'
        end
        it "returns false" do
          helper.is_moment_page?.should be_false
        end
      end
    end

    context "when the @featured_products variable isn't nil" do  
      before do
        @featured_products = ""
      end
      context "when the controller equals to 'moments'" do
        before do
          controller.params[:controller] = 'moments'
        end

        context "when the actions equals to 'show'" do
          before do
            controller.params[:action] = 'show'
          end
          it "returns true" do
            helper.is_moment_page?.should be_true
          end
        end

        context "when the actions isn't 'show'" do
          before do
            controller.params[:action] = 'fdsasfda'
          end      
          it "returns false" do
            helper.is_moment_page?.should be_false
          end
        end
      end

      context "when the controller isn't 'moments' " do
        before do
          controller.params[:controller] = 'afsdfasd'
          controller.params[:action] = 'fdsasfda'
        end

        it "returns false" do
          helper.is_moment_page?.should be_false
        end 
      end    
    end
  end  

end
