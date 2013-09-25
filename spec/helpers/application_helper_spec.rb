# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ApplicationHelper do

  describe 'should_display_footer_bar?' do
    context "AB test" do
      before do
        controller.params[:ab_t] = 'foo'
      end
      subject { helper.should_display_footer_bar? }
      it { should be_false }
    end

    context "survey controller" do
      before do
        controller.params[:controller] = 'survey'
      end
      subject { helper.should_display_footer_bar? }
      it { should be_false }
    end

    context "cart" do
      before do
        controller.params[:controller] = 'cart/cart'
      end
      subject { helper.should_display_footer_bar? }
      it { should be_false }
    end

    context "langing pages" do
      before do
        controller.params[:controller] = 'landing_pages'
      end
      subject { helper.should_display_footer_bar? }
      it { should be_false }
    end
  end


  describe "#cart_total" do
    it "returns markup for order total" do
     expected = "<span>(<span id=\"cart_items\">0 itens</span>)</span>"
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

  describe '#newsletter_type' do
    subject { helper.newsletter_type }
    context 'when cookie newsletterUser = 1' do
      before { cookies.should_receive(:[]).with('newsletterUser').and_return('1') }
      it { should be eql('-newsletter') }
    end

    context 'when cookie newsletterUser = 2' do
      before { cookies.should_receive(:[]).with('newsletterUser').and_return('2') }
      it { should be eql('-olookmovel') }
    end

    context 'when cookie newsletterUser = 0' do
      before { cookies.should_receive(:[]).with('newsletterUser').and_return('0') }
      it { should be eql('') }
    end

    context 'when there is no cookie newsletterUser' do
      before { cookies.should_receive(:[]).with('newsletterUser').and_return(nil) }
      it { should be eql('') }
    end
  end

  describe "#member_type" do
    subject { helper.member_type }

    context "when user is not logged in" do
      before { helper.stub(:user_signed_in?).and_return(false) }

      it { should == "visitor" }

      context "with newsletter_type" do
        before { helper.stub(:newsletter_type).and_return('-bla') }

        it { should == "visitor-bla" }
      end
    end

    context "when user is logged in" do
      before { helper.stub(:'user_signed_in?').and_return(true) }

      context "and user is half_user" do
        before { helper.stub_chain('current_user.half_user').and_return(true) }

        it { should eql "half" }

        context "with newsletter_type" do
          before { helper.stub(:newsletter_type).and_return('-bla') }

          it { should eql "half-bla" }
        end
      end

      context "and user is not half_user" do
        before { helper.stub_chain('current_user.half_user').and_return(false) }

        it { should eql "quiz" }

        context "with newsletter_type" do
          before { helper.stub(:newsletter_type).and_return('-bla') }

          it { should eql "quiz-bla" }
        end
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
