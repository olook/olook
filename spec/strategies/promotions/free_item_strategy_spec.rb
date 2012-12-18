require 'spec_helper'

describe Promotions::FreeItemStrategy do

  context ".initialize" do

    it "receive :promotion and :user" do
      promotion = double(:promotion)
      user = double(:user)

      strategy = Promotions::FreeItemStrategy.new(promotion, user)

      strategy.promotion.should eq(promotion)
      strategy.user.should eq(user)
    end

  end

  context "#matches?" do 

    context "when cart has only 1 item" do

      let(:cart) {FactoryGirl.create(:cart_with_items)}


      it "does not match" do

        # What if, the strategy receives only the param, instead of Promotion Object ?
        # it would be more decoupled and easier to test =p

        promotion = double(:promotion, :param => "3")
        user = double(:user)

        strategy = Promotions::FreeItemStrategy.new(promotion, user)
        strategy.matches?(cart).should be_false



      end


    end

  end

end