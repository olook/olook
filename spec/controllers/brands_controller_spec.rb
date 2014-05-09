require 'spec_helper'

describe BrandsController do
  before do
    BrandsFormat.any_instance.stub(:get_sort_brands_from_cache).and_return([])
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
