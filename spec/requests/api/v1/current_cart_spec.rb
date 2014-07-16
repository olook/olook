require 'spec_helper'

describe "CurrentCart" do
  def logged_user
    return @logged_user if @logged_user
    password = '1234asdf'
    user = FactoryGirl.create(:user, password: password, password_confirmation: password)
    post '/entrar', { user: { email: user.email, password: password } }
    @logged_user = user
  end
  describe "getting current cart" do
    context "without cart" do
      before do
        get '/api/v1/current_cart'
      end
      it { expect(response.status).to eql 200 }
      it { expect(response.body).to eq '{}' }
    end

    context "with cart" do
      before do
        @cart = logged_user.carts.create
        get '/api/v1/current_cart'
      end
      it { expect(response.status).to eql 200 }
      it { expect(response.body).to eq @cart.api_hash.to_json }
    end
  end

  describe "updating current cart" do
    context "gift_wrap" do
      before do
        put '/api/v1/current_cart', { cart: { gift_wrap: 1 } }
      end
      it { expect(JSON.parse(response.body)['gift_wrap']).to eq(true) }
    end

    context "address" do
      before do
        @address = FactoryGirl.create(:address)
        put '/api/v1/current_cart', { cart: { address_id: @address.id } }
      end
      it { expect(JSON.parse(response.body)['address']).to eq(JSON.parse(@address.api_hash.to_json)) }
    end
  end
end

