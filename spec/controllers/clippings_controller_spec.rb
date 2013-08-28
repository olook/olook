require 'spec_helper'

describe ClippingsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns @clippings" do
      clipping = FactoryGirl.create(:clipping, :published)
      get :index
      expect(assigns(:clippings)).to eq([clipping])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
