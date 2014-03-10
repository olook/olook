require 'spec_helper'

describe UserCoupon do
  let(:user_coupon) { FactoryGirl.create(:user_coupon, :with_coupon_ids) }
  let(:nil_user_coupon) { FactoryGirl.create(:user_coupon, :with_nil_coupon_ids) }
  let(:empty_user_coupon) { FactoryGirl.create(:user_coupon, :with_empty_coupon_ids) }

  describe "#add" do
    context "when the given value is blank" do
      context "and the given value is empty" do
        it "doesn't add anything" do
          ids = user_coupon.coupon_ids
          user_coupon.add ""
          expect(user_coupon.coupon_ids).to eql(ids)          
        end
      end

      context "and the given value is nil" do
        it "doesn't add anything" do
          ids = user_coupon.coupon_ids
          user_coupon.add nil
          expect(user_coupon.coupon_ids).to eql(ids)            
        end
      end      
    end

    context "when it doesn't contain any ids" do
      context "and the list is empty" do
        it "adds the given value" do
          empty_user_coupon.add("1")
          expect(empty_user_coupon.coupon_ids).to eql("1")
        end
      end

      context "and the list is nil" do
        it "adds the given value" do
          nil_user_coupon.add("1")
          expect(nil_user_coupon.coupon_ids).to eql("1")
        end
      end
    end

    context "when it contains ids other than the given one" do
      it "adds the value" do
        ids = user_coupon.coupon_ids+",123"
        user_coupon.add "123"
        expect(user_coupon.coupon_ids).to eql(ids)            
      end
    end

    context "when it contains ids and one of them is the given one" do
      it "doesn't add anything" do
        ids = user_coupon.coupon_ids
        user_coupon.add "1"
        expect(user_coupon.coupon_ids).to eql(ids)            
      end
    end
  end

  describe "#remove" do
    context "when the given value is blank" do
      context "and the given value is empty" do
        it "doesn't remove anything" do
          ids = user_coupon.coupon_ids
          user_coupon.remove ""
          expect(user_coupon.coupon_ids).to eql(ids)            
        end          
        context "and the given value is nil" do
          it "doesn't remove anything" do
            ids = user_coupon.coupon_ids
            user_coupon.remove nil
            expect(user_coupon.coupon_ids).to eql(ids)            
          end      
        end        
      end
    end

    context "when it doesn't contain any ids" do
      it "doesn't remove anything" do
        ids = empty_user_coupon.coupon_ids
        empty_user_coupon.remove "1"
        expect(empty_user_coupon.coupon_ids).to eql(ids)            
      end    
    end

    context "when it contains ids other than the given one" do
      it "doesn't remove anything" do
        ids = user_coupon.coupon_ids
        user_coupon.remove "123231"
        expect(user_coupon.coupon_ids).to eql(ids)            
      end
    end

    context "when it contains ids and one of them is the given one" do
      it "removes the given value" do
        ids = user_coupon.coupon_ids
        user_coupon.remove "1"
        expect(user_coupon.coupon_ids).to eql("4,5")            
      end
    end
  end

  describe "#include?" do
    context "when the given value is blank" do
      context "and the given value is empty" do
        it "returns false" do
          expect(user_coupon.include?("")).to be_false            
        end      
      end
      context "and the given value is nil" do
        it "returns false" do
          expect(user_coupon.include?(nil)).to be_false            
        end      
      end
    end

    context "when it doesn't contain any ids" do
      it "returns false" do
        expect(empty_user_coupon.include?("123")).to be_false            
      end
    end

    context "when it contains ids other than the given one" do
      it "returns false" do
        expect(user_coupon.include?("13214")).to be_false            
      end
    end

    context "when it contains ids and one of them is the given one" do
      it "returns true" do
        expect(user_coupon.include?("1")).to be_true            
      end
    end    
  end      
end
