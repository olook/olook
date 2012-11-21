require 'spec_helper'

class StubApplicationController < ApplicationController
  def index
    render :text => "Success"
  end
end

describe StubApplicationController do

  context "order tracking_parameters" do

    before :each do
      session[:order_tracking_params] = {:utm_source => "utm_source"}
    end

    it "should not change if utm_source is nil" do
      get :index
      session[:order_tracking_params][:utm_source].should eq("utm_source")
    end

    it "should change if utm_source is present" do
      get :index, :utm_source => "Test"
      session[:order_tracking_params][:utm_source].should eq("Test")
    end

  end

end