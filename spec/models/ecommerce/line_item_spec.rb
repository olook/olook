require 'spec_helper'

describe LineItem do

  let(:user) { FactoryGirl.create(:member) }

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type) }
  let(:user_credit) { FactoryGirl.create(:user_credit, :user => user, :credit_type => loyalty_program_credit_type) }
  let(:order) {FactoryGirl.create(:order, :user => user)}
  let(:amount) { BigDecimal.new("20.00") }
  let(:big_amount) { BigDecimal.new("100.00") }

  let(:credits_attrs) {{:amount => amount, :order => order}}
  let(:big_credits_attrs) {{:amount => big_amount, :order => order}}

  let(:basic_shoe_35) { FactoryGirl.create(:blue_sliper_with_two_variants) }

  it {should validate_presence_of(:order_id) }
  it {should validate_presence_of(:variant_id) }
  it {should validate_presence_of(:quantity) }

  before :each do
    @quantity = 2
    @variant = FactoryGirl.create(:basic_shoe_size_35)
    @line_item = FactoryGirl.create(:line_item, :variant => @variant, :quantity => @quantity, :price => @variant.price, :retail_price => @variant.retail_price)
    @normal_price = @line_item.price
  end

  it "should return the total_price" do
    @line_item.total_price.should == @variant.retail_price * @quantity
  end

  it "should return the normal price" do
    @line_item.price.should == @normal_price
  end

  it "should delegate liquidation to variant" do
    @variant.stub(:liquidation?).and_return(true)
    @line_item.liquidation?.should be_true
  end

  it "should return refund value for one line item" do
   order.line_items.create(
        :variant_id => basic_shoe_35.id,
        :quantity => 1,
        :price => 100.00,
        :retail_price => 100.00)
    line_item = order.line_items.first

    user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
    loyalty_program_credits = user.user_credits_for(:loyalty_program).credits.first

    line_item.calculate_loyalty_credit_amount.should eq(loyalty_program_credits.value)
  end

  it "should return refund value for several line items" do
   order.line_items.create(
        :variant_id => basic_shoe_35.id,
        :quantity => 1,
        :price => 100.00,
        :retail_price => 100.00)

   order.line_items.create(
        :variant_id => basic_shoe_35.id,
        :quantity => 1,
        :price => 250.00,
        :retail_price => 250.00)

   order.line_items.create(
        :variant_id => basic_shoe_35.id,
        :quantity => 1,
        :price => 150.00,
        :retail_price => 150.00)


    line_item = order.line_items.first

    user.user_credits_for(:loyalty_program).add(big_credits_attrs.dup)
    loyalty_program_credits = user.user_credits_for(:loyalty_program).credits.first

    line_item.calculate_loyalty_credit_amount.should eq(loyalty_program_credits.value/5)
  end

  it "should return refund value for several credit activities" do
   order.line_items.create(
        :variant_id => basic_shoe_35.id,
        :quantity => 1,
        :price => 100.00,
        :retail_price => 100.00)
    line_item = order.line_items.first

    user.user_credits_for(:loyalty_program).add(credits_attrs.dup)

    loyalty_program_credits = user.user_credits_for(:loyalty_program).credits.first
    line_item.calculate_loyalty_credit_amount.should eq(loyalty_program_credits.value)

    user.user_credits_for(:loyalty_program).remove(credits_attrs.dup)
    line_item.calculate_loyalty_credit_amount.should eq(loyalty_program_credits.value)

    user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
    line_item.calculate_loyalty_credit_amount.should eq(loyalty_program_credits.value)

  end

  it "should calculate debit amount for one debit" do
    order.line_items.create(
        :variant_id => basic_shoe_35.id,
        :quantity => 1,
        :price => 100.00,
        :retail_price => 100.00)
    line_item = order.line_items.first

    line_item.debits.create(
        :value => 3.0,
        :total => 3.0)

    line_item.calculate_debit_amount.should eq(3.0)
  end

  it "should calculate debit amount for many debits" do
    order.line_items.create(
        :variant_id => basic_shoe_35.id,
        :quantity => 1,
        :price => 100.00,
        :retail_price => 100.00)
    line_item = order.line_items.first

    line_item.debits.create(:value => 3.0, :total => 3.0)
    line_item.debits.create(:value => 4.0, :total => 4.0)
    line_item.debits.create(:value => 5.0, :total => 5.0)

    line_item.calculate_debit_amount.should eq(12.0)
  end  

  it "should calculate available credits" do
   order.line_items.create(
        :variant_id => basic_shoe_35.id,
        :quantity => 1,
        :price => 100.00,
        :retail_price => 100.00)
    line_item = order.line_items.first

    user.user_credits_for(:loyalty_program).add(credits_attrs.dup)
    loyalty_program_credits = user.user_credits_for(:loyalty_program).credits.first

    line_item.debits.create(:value => 3.0, :total => 3.0)

    line_item.calculate_available_credits.should eq(loyalty_program_credits.value - 3.0)
  end

  describe "when remove loyalty credits" do
    let!(:credit) {FactoryGirl.create(:credit, :source => "loyalty_program_credit", 
                                            :is_debit => false, 
                                            :value => 20.00, 
                                            :order_id => order.id)}

    it "should creating a debit with full value when amount is available" do
      order.line_items.create(
          :variant_id => basic_shoe_35.id,
          :quantity => 1,
          :price => 100.00,
          :retail_price => 100.00)
      line_item = order.line_items.first

      expect {
        line_item.remove_loyalty_credits
      }.to change{Credit.count}.by(1)

      line_item.calculate_available_credits.should eq(0)
    end

    it "should not create a debit with value 0 when amount is not available" do
      order.line_items.create(
          :variant_id => basic_shoe_35.id,
          :quantity => 1,
          :price => 100.00,
          :retail_price => 100.00)
      line_item = order.line_items.first

      credit.debits.create!({
        :source => "loyalty_program_debit",
        :is_debit => true,
        :value => 20,
        :order_id => order.id
      })

      expect {
        line_item.remove_loyalty_credits
      }.to change{Credit.count}.by(0)
    end

    it "should split debits among other debits when original credit doesn't have enough amount available" do
      FactoryGirl.create(:credit_to_expire, :source => "loyalty_program_credit", 
                                            :is_debit => false, 
                                            :order_id => order.id,
                                            :user_id => user.id)

      order.line_items.create(
          :variant_id => basic_shoe_35.id,
          :quantity => 1,
          :price => 100.00,
          :retail_price => 100.00)
      line_item = order.line_items.first

      credit.debits.create!({
        :source => "loyalty_program_debit",
        :is_debit => true,
        :value => 10,
        :order_id => order.id
      })

      expect {
        line_item.remove_loyalty_credits
      }.to change{Credit.count}.by(2)
    end
  end

end
