# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::CartController do
  let(:cart) { FactoryGirl.create(:clean_cart) }
  let(:user) { FactoryGirl.create(:user) }
  let(:basic_bag) { FactoryGirl.create(:basic_bag_simple) }
  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :redeem) }
    
  before :each do
    session[:cart_id] = cart.id
    session[:cart_freight] = mock
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  after :each do
    session[:cart_id] = nil
    session[:gift_wrap] = nil
    session[:cart_coupon] = nil
    session[:cart_credits] = nil
    session[:cart_freight] = nil
  end
  
  it "should erase freight when call any action" do
    session[:cart_freight] = mock
    get :show
    assigns(:cart_service).freight.should be_nil
  end
  
  context "when show" do
    it "should assign default bonus value" do
      get :show
      assigns(:bonus).should eq(0)
    end
    
    it "should assign bonus value for user" do
      session[:cart_credits] = 10
      User.any_instance.should_receive(:credits_for?).with(10).and_return(100)
      sign_in user
      get :show
      assigns(:bonus).should eq(100)
    end

    it "should render show view" do
      get :show
      response.should render_template ["layouts/site", "show"]
    end
  end
  
  context "when destroy" do
    it "should remove cart in database" do
      Cart.any_instance.should_receive(:destroy)
      delete :destroy
      response.should redirect_to(cart_path)
      flash[:notice].should eql("Sua sacola está vazia")
    end
    
    it "should reset session params" do
      delete :destroy
      session[:cart_id].should be_nil
      session[:gift_wrap].should be_nil
      session[:cart_coupon].should be_nil
      session[:cart_credits].should be_nil
      session[:cart_freight].should be_nil
    end

    it "should set flash notice" do
      delete :destroy
      flash[:notice].should eql("Sua sacola está vazia")
    end
    
    it "should redirect to cart" do
      delete :destroy
      response.should redirect_to(cart_path)
    end
  end

  context "when update" do
    it "should remove item" do
      Cart.any_instance
          .should_receive(:remove_item)
          .with(basic_bag)
          .and_return(true)
      post :update, {variant: {id: basic_bag.id}}
    end
    
    context "when item removed and respond for html" do
      before :each do
        Cart.any_instance
            .stub(:remove_item)
            .with(basic_bag)
            .and_return(true)
      end

      it "should redirect to cart" do
        post :update, {variant: {id: basic_bag.id}}
        response.should redirect_to(cart_path)
      end
  
      it "should set flash notice" do
        post :update, {variant: {id: basic_bag.id}}
        flash[:notice].should eql("Produto removido com sucesso")
      end
    end
    
    it "should head is ok when item removed and respond for js" do
      Cart.any_instance
          .stub(:remove_item)
          .with(basic_bag)
          .and_return(true)
      
      request.env['HTTP_ACCEPT'] = "text/javascript"
      post :update, {variant: {id: basic_bag.id}}, :format=> :js
      response.code.should eq("200")
      response.body.should be_blank
    end

    context "when item is not removed and respond for html" do
      before :each do
        Cart.any_instance
            .stub(:remove_item)
            .with(basic_bag)
            .and_return(false)
      end

      it "should redirect to cart" do
        post :update, {variant: {id: basic_bag.id}}
        response.should redirect_to(cart_path)
      end
  
      it "should set flash notice" do
        post :update, {variant: {id: basic_bag.id}}
        flash[:notice].should eql("Este produto não está na sua sacola")
      end
    end

    it "should head is not when item is not removed and respond for js" do
      Cart.any_instance
          .stub(:remove_item)
          .with(basic_bag)
          .and_return(false)

      request.env['HTTP_ACCEPT'] = "text/javascript"
      post :update, {variant: {id: basic_bag.id}}, :format=> :js
      response.code.should eq("404")
      response.body.should be_blank
    end
  end

  context "when add item" do
    it "should assign variant" do
      post :create, {variant: {id: basic_bag.id}}
      assigns(:variant).should eq(basic_bag)
    end
    
    context "when no has valid variant" do
      it "should render error in response for js" do
        request.env['HTTP_ACCEPT'] = "text/javascript"
        post :create, :format=> :js
        response.should render_template ["error"]
      end

      it "should redirect to back in response for html" do
        request.env['HTTP_REFERER'] = "http://back.page"
        post :create
        response.should redirect_to("http://back.page")
      end
      it "shoudl set flash notice in response for html" do
        request.env['HTTP_REFERER'] = "http://back.page"
        post :create
        flash[:notice].should eql("Produto não disponível para esta quantidade ou inexistente")
      end
    end
    
    context "when has valid variant" do
      it "should add item" do
        Cart.any_instance
            .should_receive(:add_item)
            .with(basic_bag)
            .and_return(true)
        post :create, {variant: {id: basic_bag.id}}
      end

      context "when item added and respond for html" do
        before :each do
          Cart.any_instance
              .stub(:add_item)
              .with(basic_bag)
              .and_return(true)
        end
        
        it "should redirect to cart" do
          post :create, {variant: {id: basic_bag.id}}
          response.should redirect_to(cart_path)
        end
        
        it "should set flash notice" do
          post :create, {variant: {id: basic_bag.id}}
          flash[:notice].should eql("Produto adicionado com sucesso")
        end
      end

      it "should render create when item added and respond for js" do
        request.env['HTTP_ACCEPT'] = "text/javascript"
        post :create, {variant: {id: basic_bag.id}}, :format=> :js
        response.should render_template ["create"]
      end

      context "when item is not added and respond for html" do
        before :each do
          Cart.any_instance
              .stub(:add_item)
              .with(basic_bag)
              .and_return(false)
        end

        it "should redirect to cart" do
          post :create, {variant: {id: basic_bag.id}}
          response.should redirect_to(cart_path)
        end

        it "should set flash notice" do
          post :create, {variant: {id: basic_bag.id}}
          flash[:notice].should eql("Produto esgotado")
        end
      end

      context "when item is not added and respond for js" do
        before :each do
          Cart.any_instance
              .stub(:add_item)
              .with(basic_bag)
              .and_return(false)
          request.env['HTTP_ACCEPT'] = "text/javascript"
        end

        it "should render error" do
          post :create, {variant: {id: basic_bag.id}}, :format=> :js
          response.should render_template ["error"]
        end
      end
    end
  end
  
  
  context "when update gift wrap" do
    it "should update session" do
      post :update_gift_wrap, {gift: {gift_wrap: "true"}}
      session[:gift_wrap].should eq("true")
    end
    
    it "should response true for json" do
      post :update_gift_wrap, {gift: {gift_wrap: "true"}}
      response.body.should eq("true")
    end
  end

  context "when update coupon" do
    it "should redirect to cart" do
      post :update_coupon
      response.should redirect_to(cart_path)
    end
    
    context "when has valid coupon" do
      let(:coupon) do
        coupon = double(Coupon)
        coupon.stub(:expired?).and_return(false)
        coupon.stub(:available?).and_return(true)
        coupon
      end
      
      before :each do
        Coupon.should_receive(:find_by_code).with("CODE").and_return(coupon)
        post :update_coupon, {coupon: {code: "CODE"}}
      end
      
      it "should set flash" do
        flash[:notice].should eql("Cupom atualizado com sucesso")
      end

      it "should set session" do
        session[:cart_coupon].should be(coupon)
      end
    end
    
    context "when has invalid coupon" do
      let(:coupon) do
        coupon = double(Coupon)
        coupon.stub(:expired?).and_return(false)
        coupon.stub(:available?).and_return(false)
        coupon
      end
      
      before :each do
        Coupon.should_receive(:find_by_code).with("CODE").and_return(coupon)
        post :update_coupon, {coupon: {code: "CODE"}}
      end
      
      it "should set flash" do
        flash[:notice].should eql("Cupom inválido")
      end
      
      it "should set session" do
        session[:cart_coupon].should be_nil
      end
    end

    context "when has expired coupon" do
      let(:coupon) do
        coupon = double(Coupon)
        coupon.stub(:reload)
        coupon.stub(:expired?).and_return(true)
        coupon
      end
      
      before :each do
        Coupon.should_receive(:find_by_code).with("CODE").and_return(coupon)
        post :update_coupon, {coupon: {code: "CODE"}}
      end
      
      it "should set flash" do
        flash[:notice].should eql("Cupom expirado. Informe outro por favor")
      end
      
      it "should set session" do
        session[:cart_coupon].should be_nil
      end
    end
  end
  
  context "when remove coupon" do
    let(:coupon) do
      coupon = double(Coupon)
      coupon.stub(:reload)
      coupon
    end
    
    it "should redirect to cart" do
      post :remove_coupon
      response.should redirect_to(cart_path)
    end
    
    it "should set session" do
      session[:cart_coupon] = coupon
      post :remove_coupon
      session[:cart_coupon].should be_nil
    end
    
    it "should set flash when has valid coupon in session" do
      session[:cart_coupon] = coupon
      post :remove_coupon
      flash[:notice].should eq("Cupom removido com sucesso")
    end
    
    it "should set flash when has invalid coupon in session" do
      post :remove_coupon
      flash[:notice].should eq("Você não está usando cupom")
    end
  end

  context "when remove credits" do
    it "should redirect to cart" do
      post :remove_credits
      response.should redirect_to(cart_path)
    end

    it "should set flash when has invalid credits in cart" do
      post :remove_credits
      flash[:notice].should eq("Você não está usando nenhum crédito")
    end

    it "should set session when has credits in cart" do
      post :remove_credits
      session[:cart_credits].should be(0)
    end
    
    it "should set flash when has credits in cart" do
      session[:cart_credits] = 100
      post :remove_credits
      flash[:notice].should eq("Créditos removidos com sucesso")
    end
  end
  
  context "when update credits" do
    before :each do
      Cart.any_instance.stub(:cart_credits_discount).and_return(100)
      sign_in user
    end
    
    it "should redirect to cart" do
      post :update_credits
      response.should redirect_to(cart_path)
    end
    
    it "should set flash when user no has sufficient credit" do
      User.any_instance.stub(:can_use_credit?).and_return(false)
      post :update_credits, {credits: {value: 100}}
      flash[:notice].should eq("Você não tem créditos suficientes")
    end
    
    context "and has sufficient credit" do
      before :each do
        User.any_instance.stub(:can_use_credit?).and_return(true)
        CartService.any_instance.stub(:total_credits_discount).and_return(100)
      end

      it "should set session" do
        post :update_credits, {credits: {value: 100}}
        session[:cart_credits].should eq(100)
      end
      
      it "should set flash" do
        post :update_credits, {credits: {value: 100}}
        flash[:notice].should eq("Créditos atualizados com sucesso")
      end
      
      it "should set flash for max value" do
        post :update_credits, {credits: {value: 110}}
        flash[:notice].should eq("Você tentou utilizar mais que o permitido para esta compra, utilizamos o máximo permitido.")
      end
    end
  end
end

