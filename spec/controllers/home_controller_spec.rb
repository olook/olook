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

      context 'when the site do not receive extra parameters' do
        before :each do
          subject.stub(:params).and_return(standard_params)
        end

        context 'and the tracking params on the session is empty' do
          before :each do
            subject.session[:tracking_params] = nil
          end

          it 'should remaining empty' do
            subject.send(:save_tracking_params)
            subject.session[:tracking_params].should be_nil
          end
        end

        context 'and the tracking params on the session is not empty' do
          let(:old_params) { {:old => 'tracking'} }
          before :each do
            subject.session[:tracking_params] = old_params
          end

          it 'should keep the old parameters' do
            subject.send(:save_tracking_params)
            subject.session[:tracking_params].should == old_params
          end
        end
      end
    end
  end

end
