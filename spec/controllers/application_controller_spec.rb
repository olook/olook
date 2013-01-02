require 'spec_helper'

class StubApplicationController < ApplicationController
  def index
    render :text => "Success"
  end
end

Olook::Application.routes.draw { get "stub_application/index" }

describe StubApplicationController do

  context "order tracking_parameters" do

    before :each do
      session[:order_tracking_params] = {:utm_source => "utm_source", :referer => "localhost"}
    end

    it "should not change if utm_source is nil" do
      get :index
      session[:order_tracking_params][:utm_source].should eq("utm_source")
    end

    it "should change if utm_source is present" do
      get :index, :utm_source => "Test"
      session[:order_tracking_params][:utm_source].should eq("Test")
    end

    it "should not change if referer is www.olook.com.br" do
      request.stub(:referer).and_return "www.olook.com.br"
      get :index
      session[:order_tracking_params][:referer].should eq("localhost")
    end

    it "should not change if referer is app1.olook.com.br" do
      request.stub(:referer).and_return "app1.olook.com.br"
      get :index
      session[:order_tracking_params][:referer].should eq("localhost")
    end

    it "should change if referer is external" do
      request.stub(:referer).and_return "www.google.com.br"
      get :index
      session[:order_tracking_params][:referer].should eq("www.google.com.br")
    end

  end

end