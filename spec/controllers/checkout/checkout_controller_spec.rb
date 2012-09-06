# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::CheckoutController do  
  let(:credit_card_attributes) {{"user_name"=>"Joao", "credit_card_number"=>"1111222233334444", "security_code"=>"456",
                     "user_birthday"=>"28/01/1987", "expiration_date"=>"01/14", "user_identification"=>"067.239.146-51", 
                     "telephone"=>"(35)7648-6749", "payments"=>"1", "bank"=>"Visa", "receipt" => "AVista" }}

  let(:debit_attributes) {{"bank"=>"BancoDoBrasil", "receipt" => Payment::RECEIPT}}

  let(:cpf) { "600.745.487-86" }
  let(:order) { FactoryGirl.create(:order, :user => user) }
  let(:user) { FactoryGirl.create :user, :cpf => nil }
  let(:user_with_cpf) { FactoryGirl.create :user, :cpf => cpf }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:cart_without_items) { FactoryGirl.create(:clean_cart, :user => user) }
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  
  let(:freight) { { :price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id, :address_id => address.id} }

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :redeem) }

  let(:coupon_expired) do
    coupon = double(Coupon)
    coupon.stub(:reload)
    coupon.stub(:expired?).and_return(true)
    coupon.stub(:available?).and_return(false)
    coupon
  end
  let(:coupon_not_more_available) do
    coupon = double(Coupon)
    coupon.stub(:reload)
    coupon.stub(:expired?).and_return(false)
    coupon.stub(:available?).and_return(false)
    coupon
  end  

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  
  after :each do
    session[:cart_id] = nil
    session[:gift_wrap] = nil
    session[:cart_coupon] = nil
    session[:cart_use_credits] = nil
    session[:cart_freight] = nil
  end

  it "should redirect user to login when is offline" do
    get :new
    response.should redirect_to(new_user_session_path)
  end

  context "checking" do
    before :each do
      sign_in user
    end
    
    it "should redirect to cart_path when cart is empty" do
      session[:cart_id] = nil
      get :new
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Sua sacola está vazia")
    end
    
    it "should remove unavailabe items" do
      session[:cart_id] = cart.id
      Cart.any_instance.should_receive(:remove_unavailable_items).and_return(true)
      get :new
    end
    
    it "should redirect to cart_path when cart items is empty" do
      session[:cart_id] = cart_without_items.id
      get :new
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Sua sacola está vazia")
    end

    it "should remove coupon from session when coupon is expired" do
      session[:cart_id] = cart.id
      session[:cart_coupon] = coupon_expired
      get :new
      session[:cart_coupon].should be_nil
    end

    it "should redirect to cart_path when coupon is expired" do
      session[:cart_id] = cart.id
      session[:cart_coupon] = coupon_expired
      get :new
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Cupom expirado. Informe outro por favor")
    end
        
    it "should remove coupon from session when coupon is not more avialbe" do
      session[:cart_id] = cart.id
      session[:cart_coupon] = coupon_not_more_available
      get :new
      session[:cart_coupon].should be_nil
    end
    
    it "should redirect to cart_path when coupon is not more availabe" do
      session[:cart_id] = cart.id
      session[:cart_coupon] = coupon_not_more_available
      get :new
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Cupom expirado. Informe outro por favor")
    end
    
    it "should redirect to new_cart_checkout_path when user doesn't have freight data" do
      session[:cart_id] = cart.id
      get :new_credit_card
      response.should redirect_to(cart_checkout_addresses_path)
      flash[:notice].should eq("Escolha seu endereço")
    end

    it "should redirect to new_cart_checkout_path when user doesn't have a CPF" do
      session[:cart_id] = cart.id
      session[:cart_freight] = freight
      get :new_credit_card
      response.should redirect_to(new_cart_checkout_path)
      flash[:notice].should eq("Informe seu CPF")
    end
  end  

  context "PUT update" do
    before :each do
      sign_in user
      session[:cart_id] = cart.id
      session[:cart_freight] = freight
    end

    it "should check have params" do
      put :update
      response.should render_template('new')
      flash[:notice].should eq("CPF inválido")
    end
    
    it "should check cpf is valid" do
      put :update, :user => {:cpf => "BLABLA"}
      response.should render_template('new')
      flash[:notice].should eq("CPF inválido")
    end
    
    it "should updates the CPF" do
      put :update, :user => {:cpf => cpf}
      flash[:notice].should eq("CPF cadastrado com sucesso")
    end

    it "should not updates the CPF when already has one" do
      user.update_attributes(:cpf => cpf)
      User.any_instance.should_not_receive(:save)
      put :update, :user => {:cpf => cpf}
      flash[:notice].should eq("CPF já cadastrado")
    end
  end

  context "GET new_billet" do
    before :each do
      sign_in user_with_cpf
      session[:cart_id] = cart.id
      session[:cart_freight] = freight
    end

    it "should assigns @payment" do
      get 'new_billet'
      assigns(:payment).should be_a_new(Billet)
    end
  end
  
  context "GET new_credit_card" do
    before :each do
      sign_in user_with_cpf
      session[:cart_id] = cart.id
      session[:cart_freight] = freight
    end

    it "creates new credit card using user data" do
      CreditCard.should_receive(:user_data).with(user_with_cpf)
      get 'new_credit_card'
    end

    it "should assigns @payment" do
      get 'new_credit_card'
      assigns(:payment).should be_a_new(CreditCard)
    end
  end
  
  context "GET new_debit" do
    before :each do
      sign_in user_with_cpf
      session[:cart_id] = cart.id
      session[:cart_freight] = freight
    end

   it "should assigns @payment" do
      get 'new_debit'
      assigns(:payment).should be_a_new(Debit)
    end
  end

  context "POST create_billet" do
    before :each do
      sign_in user_with_cpf
      session[:cart_id] = cart.id
      session[:cart_freight] = freight
    end
    
    it "should inject cpf in payment" do
      post :create_billet
      assigns(:payment).user_identification.should eq(user_with_cpf.cpf)
    end

    xit "should redirects to cath path with some variant unavailable" do
      PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
      payment_builder.stub(:process!).and_return(OpenStruct.new(:status => Product::UNAVAILABLE_ITEMS, :payment => nil))
      post :create_billet
      
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Produtos com o baixa no estoque foram removidos de sua sacola")
    end
    
    context "with valid payment" do
      before :each do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = mock)
        payment_builder.should_receive(:process!).and_return(OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => mock_model(Billet, :order => order)))
        post :create_billet
      end
      
      it "should clean the session order" do
        session[:cart_id].should be_nil
        session[:gift_wrap].should be_nil
        session[:cart_coupon].should be_nil
        session[:cart_use_credits].should be_nil
        session[:cart_freight].should be_nil
      end
      
      it "should redirect to order_show_path" do
        response.should redirect_to(order_show_path(:number => order.number))
        flash[:notice].should eq("Boleto gerado com sucesso")
      end
    end
      
    context "with invalid params" do
      before :each do
        processed_payment = OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => mock_model(Billet))
        payment_builder = mock
        payment_builder.stub(:process!).and_return(processed_payment)
        PaymentBuilder.stub(:new).and_return(payment_builder)
        post :create_billet
      end

      it "should re-inject cpf" do
        assigns(:payment).user_identification.should eq(user_with_cpf.cpf)
      end

      it "should render new template" do
        response.should render_template('new_billet')
        assigns(:payment).errors[:id].should include("Não foi possível realizar o pagamento. Tente novamente por favor.")
      end
    end
  end

  context "POST create_credit_card" do
    before :each do
      sign_in user_with_cpf
      session[:cart_id] = cart.id
      session[:cart_freight] = freight
    end
    
    it "should render new_credit_card when has no params" do
      post :create_credit_card
      response.should render_template('new_credit_card')
    end

    it "should assign bank" do
      post :create_credit_card, {:credit_card => credit_card_attributes}
      assigns(:bank).should eq(credit_card_attributes["bank"])
    end

    it "should assign installments" do
      post :create_credit_card, {:credit_card => credit_card_attributes}
      assigns(:installments).should eq(credit_card_attributes["payments"])
    end
    
    it "should inject cpf in payment" do
      post :create_credit_card, {:credit_card => credit_card_attributes}
      assigns(:payment).user_identification.should eq(user_with_cpf.cpf)
    end

    xit "should redirects to cath path with some variant unavailable" do
      PaymentBuilder.should_receive(:new).and_return(payment_builder = double(PaymentBuilder))
      payment_builder.should_receive(:credit_card_number=).with(credit_card_attributes["credit_card_number"])
      payment_builder.stub(:process!).and_return(OpenStruct.new(:status => Product::UNAVAILABLE_ITEMS, :payment => nil))
      post :create_credit_card, {:credit_card => credit_card_attributes}
      
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Produtos com o baixa no estoque foram removidos de sua sacola")
    end
    
    context "with valid payment" do
      before :each do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = double(PaymentBuilder))
        payment_builder.should_receive(:credit_card_number=).with(credit_card_attributes["credit_card_number"])
        payment_builder.should_receive(:process!).and_return(OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => mock_model(CreditCard, :order => order)))
        post :create_credit_card, {:credit_card => credit_card_attributes}
      end
      
      it "should clean the session order" do
        session[:cart_id].should be_nil
        session[:gift_wrap].should be_nil
        session[:cart_coupon].should be_nil
        session[:cart_use_credits].should be_nil
        session[:cart_freight].should be_nil
      end
      
      it "should redirect to order_show_path" do
        response.should redirect_to(order_show_path(:number => order.number))
        flash[:notice].should eq("Pagamento realizado com sucesso")
      end
    end
      
    context "with invalid params" do
      before :each do
        PaymentBuilder.stub(:new).and_return(payment_builder = double(PaymentBuilder))
        payment_builder.should_receive(:credit_card_number=).with(credit_card_attributes["credit_card_number"])
        payment_builder.stub(:process!).and_return(OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => mock_model(CreditCard)))
        post :create_credit_card, {:credit_card => credit_card_attributes}
      end

      it "should re-inject cpf" do
        assigns(:payment).user_identification.should eq(user_with_cpf.cpf)
      end

      it "should render new template" do
        response.should render_template('new_credit_card')
        assigns(:payment).errors[:id].should include("Erro no pagamento. Verifique os dados de seu cartão ou tente outra forma de pagamento.")
      end
    end
  end
  
  context "POST create_debit" do
    before :each do
      sign_in user_with_cpf
      session[:cart_id] = cart.id
      session[:cart_freight] = freight
    end
    
    it "should render new_debit when has no params" do
      post :create_debit
      response.should render_template('new_debit')
    end

    it "should inject cpf in payment" do
      post :create_debit, {:debit => debit_attributes}
      assigns(:payment).user_identification.should eq(user_with_cpf.cpf)
    end

    xit "should redirects to cath path with some variant unavailable" do
      PaymentBuilder.should_receive(:new).and_return(payment_builder = double(PaymentBuilder))
      payment_builder.stub(:process!).and_return(OpenStruct.new(:status => Product::UNAVAILABLE_ITEMS, :payment => nil))
      post :create_debit, {:debit => debit_attributes}
      
      response.should redirect_to(cart_path)
      flash[:notice].should eq("Produtos com o baixa no estoque foram removidos de sua sacola")
    end
    
    context "with valid payment" do
      before :each do
        PaymentBuilder.should_receive(:new).and_return(payment_builder = double(PaymentBuilder))
        payment_builder.should_receive(:process!).and_return(OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => mock_model(Debit, :order => order)))
        post :create_debit, {:debit => debit_attributes}
      end
      
      it "should clean the session order" do
        session[:cart_id].should be_nil
        session[:gift_wrap].should be_nil
        session[:cart_coupon].should be_nil
        session[:cart_use_credits].should be_nil
        session[:cart_freight].should be_nil
      end
      
      it "should redirect to order_show_path" do
        response.should redirect_to(order_show_path(:number => order.number))
        flash[:notice].should eq("Link de pagamento gerado com sucesso")
      end
    end
      
    context "with invalid params" do
      before :each do
        PaymentBuilder.stub(:new).and_return(payment_builder = double(PaymentBuilder))
        payment_builder.stub(:process!).and_return(OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => mock_model(Debit)))
        post :create_debit, {:debit => debit_attributes}
      end

      it "should re-inject cpf" do
        assigns(:payment).user_identification.should eq(user_with_cpf.cpf)
      end

      it "should render new template" do
        response.should render_template('new_debit')
        assigns(:payment).errors[:id].should include("Não foi possível realizar o pagamento. Tente novamente por favor.")
      end
    end
  end
end
