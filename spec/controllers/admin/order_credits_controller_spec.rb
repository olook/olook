require 'spec_helper'

describe Admin::OrderCreditsController do
  
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe 'GET index' do
    context "Autorized or Delivered orders" do
      let!(:delivered_order) { FactoryGirl.create(:delivered_order, :amount_discount => 200) }

      it "should assigns orders" do
        get :index
        assigns(:orders).should == [delivered_order]
      end

      it "should assigns orders ordered by amount of credit used" do
        order = FactoryGirl.create(:delivered_order, :amount_discount => 300) 
        get :index
        assigns(:orders).should == [order, delivered_order]
      end
    end
  end

  describe 'GET orders_filtered_by_range' do

    let!(:order_out_of_range) {FactoryGirl.create(:delivered_order, amount_discount: 99 , created_at: 2.days.ago)}
    let!(:order_range_member) {FactoryGirl.create(:delivered_order, amount_discount: 100, created_at: 1.day.ago)}

    context "Date" do
      it "should assings orders filtered by a range of date" do
        get :orders_filtered_by_date, {:start_at => 1.day.ago, :end_at => Time.zone.now}
        assigns(:orders).should_not include(order_out_of_range)
        assigns(:orders).should eq([order_range_member])
        response.should render_template(:index)
      end
    end

    context "credit" do
      it "should assings orders filtered by a range of credits amount" do
        get :orders_filtered_by_range, {:min_amount_discount => 100, :max_amount_discount => 115}
        assigns(:orders).should_not include(order_out_of_range)
        assigns(:orders).should eq([order_range_member])
        response.should render_template(:index)
      end
    end
  end

  describe 'GET orders_filtered_by_credit_type' do
    it "should assings orders filtered by type of credit"
  end
end