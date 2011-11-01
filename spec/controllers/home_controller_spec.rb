# -*- encoding : utf-8 -*-
require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
  
  describe 'filters' do
    describe '#redirect_logged_user' do
      it 'should redirect to the member invite if the user is logged in' do
        subject.stub(:'user_signed_in?').and_return(true)
        subject.should_receive(:redirect_to)
        subject.send(:redirect_logged_user)
      end

      it 'should do nothing if the user is logged in' do
        subject.stub(:'user_signed_in?').and_return(false)
        subject.should_not_receive(:redirect_to)
        subject.send(:redirect_logged_user)
      end
    end

    describe '#save_tracking_params' do
      let(:standard_params) { {'controller' => 'test_controller', 'action' => 'test_action'} }
      it 'when the site receives extra parameters they should be saved to the session' do
        standard_params[:tracking_xyz] = 'test_tracking'
        subject.stub(:params).and_return(standard_params)
        subject.send(:save_tracking_params)
        subject.session[:tracking_params].should == {:tracking_xyz => 'test_tracking'}
      end

      it 'when the site do not receive extra parameters the tracking params on the session should be empty' do
        subject.stub(:params).and_return(standard_params)
        subject.send(:save_tracking_params)
        subject.session[:tracking_params].should be_empty
      end
    end
  end

end
