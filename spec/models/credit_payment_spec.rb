# == Schema Information
#
# Table name: payments
#
#  id                         :integer          not null, primary key
#  order_id                   :integer
#  url                        :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  type                       :string(255)
#  state                      :string(255)
#  user_name                  :string(255)
#  credit_card_number         :string(255)
#  bank                       :string(255)
#  expiration_date            :string(255)
#  telephone                  :string(255)
#  user_birthday              :string(255)
#  payments                   :integer
#  gateway_status             :integer
#  gateway_code               :string(255)
#  gateway_type               :string(255)
#  payment_expiration_date    :datetime
#  reminder_sent              :boolean          default(FALSE)
#  gateway_status_reason      :string(255)
#  identification_code        :string(255)
#  cart_id                    :integer
#  credit_type_id             :integer
#  credit_ids                 :text
#  coupon_id                  :integer
#  total_paid                 :decimal(8, 2)
#  promotion_id               :integer
#  discount_percent           :integer
#  percent                    :decimal(8, 2)
#  gateway_response_id        :string(255)
#  gateway_response_status    :string(255)
#  gateway_token              :text
#  gateway_fee                :decimal(8, 2)
#  gateway_origin_code        :string(255)
#  gateway_transaction_status :string(255)
#  gateway_message            :string(255)
#  gateway_transaction_code   :string(255)
#  gateway_return_code        :integer
#  user_id                    :integer
#  gateway                    :integer
#  security_code              :string(255)
#

require 'spec_helper'

describe CreditPayment do
  it { should belong_to(:credit_type) }
  it { should validate_presence_of(:credit_type_id) }
  
  let(:order) { mock_model(Order, :payment_rollback? => false, :canceled => true, :refunded => true, :reversed => true) }
  let(:credit_type) { mock_model(CreditType, :code => :credit_type) }
  let(:user) { mock_model(User, :user_credits_for => credit_type) }
  let(:total_paid) { 100.00 }

  let(:credit_1) { mock_model(Credit) }
  let(:credit_2) { mock_model(Credit) }

  subject { CreditPayment.new(:credit_type => credit_type, :order => order, :user => user, :total_paid => total_paid) }

  context "when deliver payment" do
    it "should remove credits for user" do
      credit_type.should_receive(:remove)
                 .with({amount: total_paid, order_id: order.id})
      subject.deliver_payment?
    end
    
    it "should update credit_ids with credits debits used" do
      credit_type.stub(:remove)
                 .and_return([credit_1, credit_2])
      subject.should_receive(:update_column)
             .with(:credit_ids, "#{credit_1.id},#{credit_2.id}")
      subject.deliver_payment?
    end
  end
  
  context "when cancel payment" do
    it "should cancel order" do
      order.should_receive(:canceled)
      subject.cancel_order?
    end
    
    it "should not cancel order if it is already" do
      order.stub(:payment_rollback? => true)
      order.should_not_receive(:canceled)
      subject.cancel_order?
    end
    
    it "should delete credit for credits debits used" do
      subject.stub(:credit_ids => "#{credit_1.id},#{credit_2.id}")
      subject.stub(:update_column)
      credit_1.should_receive(:delete).twice
      Credit.stub(:find).and_return(credit_1)
      subject.cancel_order?
    end
    
    it "should erase credit_ids" do
      subject.stub(:credit_ids => "#{credit_1.id},#{credit_2.id}")
      subject.should_receive(:update_column).with(:credit_ids, '')
      Credit.stub(:find)
      subject.cancel_order?
    end
  end

  context "when reverse payment" do
    it "should reverse order" do
      order.should_receive(:reversed)
      subject.reverse_order?
    end
    
    it "should not reverse order if it is already" do
      order.stub(:payment_rollback? => true)
      order.should_not_receive(:reversed)
      subject.reverse_order?
    end
    
    it "should delete credit for credits debits used" do
      subject.stub(:credit_ids => "#{credit_1.id},#{credit_2.id}")
      subject.stub(:update_column)
      credit_1.should_receive(:delete).twice
      Credit.stub(:find).and_return(credit_1)
      subject.reverse_order?
    end
    
    it "should erase credit_ids" do
      subject.stub(:credit_ids => "#{credit_1.id},#{credit_2.id}")
      subject.should_receive(:update_column).with(:credit_ids, '')
      Credit.stub(:find)
      subject.reverse_order?
    end
  end

  context "when refund payment" do
    it "should refund order" do
      order.should_receive(:refunded)
      subject.refund_order?
    end
    
    it "should not refund order if it is already" do
      order.stub(:payment_rollback? => true)
      order.should_not_receive(:refunded)
      subject.refund_order?
    end
    
    it "should delete credit for credits debits used" do
      subject.stub(:credit_ids => "#{credit_1.id},#{credit_2.id}")
      subject.stub(:update_column)
      credit_1.should_receive(:delete).twice
      Credit.stub(:find).and_return(credit_1)
      subject.refund_order?
    end
    
    it "should erase credit_ids" do
      subject.stub(:credit_ids => "#{credit_1.id},#{credit_2.id}")
      subject.should_receive(:update_column).with(:credit_ids, '')
      Credit.stub(:find)
      subject.refund_order?
    end
  end
end
