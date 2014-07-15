require 'spec_helper'

describe "CurrentCart" do
  context "without cart" do
    before do
      get '/api/v1/current_cart'
    end
    it { expect(response.status).to eql 200 }
    it { expect(response.body).to eq '{}' }
  end

  context "with cart" do
    before do
      password = '1234asdf'
      user = FactoryGirl.create(:user, password: password, password_confirmation: password)
      @cart = user.carts.create
      post '/entrar', { user: { email: user.email, password: password } }
      get '/api/v1/current_cart'
    end
    it { expect(response.status).to eql 200 }
    it { expect(response.body).to eq @cart.api_json }

  end
end

