require 'spec_helper'

describe ::User::OrdersController do
  let(:user) { FactoryGirl.create(:user, :orders => [ FactoryGirl.create(:order)] ) }

  before(:each) do
    sign_in user
  end

  describe "GET index" do
    it "assigns @orders with payment" do
      orders_with_payment = user.orders.with_payment.all

      get 'index'
      assigns(:orders).should == orders_with_payment
    end
  end

  describe "GET show" do
    let(:order) { user.orders.first }

    it "assings @current_order" do
      get :show, :number => order.number
      assigns(:current_order).should == order
    end

    it "assigns @address" do
      address_order = user.orders.first.freight.address

      get :show, :number => order.number
      assigns(:address).should == address_order
    end

    it "creates a new order status presenter using the order" do
      OrderStatus.should_receive(:new).with(order)
      get :show, :number => order.number
    end

    it "assigns @order_presenter" do
      status = mock('status')
      OrderStatus.stub(:new).and_return(status)

      get :show, :number => order.number
      assigns(:order_presenter).should == status
    end

  end

end