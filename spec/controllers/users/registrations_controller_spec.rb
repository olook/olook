# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Users::RegistrationsController do

  let(:user_attributes) { {"email" => "mail@mail.com", "password" => "123456", "password_confirmation" => "123456", "first_name" => "User Name", "last_name" => "Last Name" } }
  let(:user_attributes_invalid) { {"email" => "mail@mail.com", "password" => "12345", "password_confirmation" => "123456", "first_name" => "User Name", "last_name" => "Last Name" } }
  let(:half_user_attributes) { user_attributes.merge({"half_user" => true , "gender" => "1"}) }
  let(:woman_half_user_attributes) { user_attributes.merge({"half_user" => true , "gender" => "0"}) }
  let(:half_user_attributes_invalid) { user_attributes_invalid.merge({"half_user" => true}) }

  let(:birthday) { {:day => "27", :month => "9", :year => "1987"} }
  let(:birthday_date) { Date.new(1987, 9, 27) }
  let(:facebook_data) { {"extra" => {"raw_info" => {"first_name" => "Maria", "last_name" => "Alencar", "id" => "12876556"}}, "credentials" => {"token" => "abc"}} }
  let(:inviting_member) { FactoryGirl.create(:member) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => "invite") }

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :redeem) }

  render_views

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  after :each do
    session[:cart_id] = nil
    session[:recipient_id] = nil
    session[:occasion_id] = nil
    session[:profile_questions] = nil
    session[:profile_birthday] = nil
    session[:tracking_params] = nil
    session["devise.facebook_data"] = nil
    session[:invite] = nil
  end

  describe "registration form" do
    context "when is full user" do
      it "should redirect if the user don't fill the Survey" do
        session[:profile_questions] = nil
        session[:profile_birthday] = :some_data
        get :new
        response.should redirect_to(wysquiz_path)
      end

      it "should redirect if the user don't fill the birthday" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = nil
        get :new
        response.should redirect_to(wysquiz_path)
      end

      it "should render new when user fill the Survey" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        get :new
        response.should render_template ["layouts/site", "new"]
      end

      it "should not build the resource using session data" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        get :new
        controller.resource.email.should eq(nil)
      end

      it "should assigns @signup_with_facebook" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        session["devise.facebook_data"] = facebook_data
        get :new
        assigns(:signup_with_facebook).should eq(true)
      end

      it "should build the resource using session data" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        session["devise.facebook_data"] = facebook_data
        get :new
        controller.resource.uid.should eq("12876556")
        controller.resource.first_name.should eq("Maria")
        controller.resource.last_name.should eq("Alencar")
        controller.resource.facebook_token.should eq("abc")
      end
    end

    context "when is half user" do
      it "should render new_half" do
        get :new_half
        response.should render_template ["layouts/site", "new_half"]
      end
    end
  end

  describe "sign up" do

    context "when is full user" do
      it "should redirect if the user don't fill the Survey" do
        session[:profile_questions] = nil
        session[:profile_birthday] = :some_data
        post :create, :user => user_attributes
        response.should redirect_to(wysquiz_path)
      end

      it "should redirect if the user don't fill the birthday" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = nil
        post :create, :user => user_attributes
        response.should redirect_to(wysquiz_path)
      end

      it "should save user" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        ProfileBuilder.stub(:factory)
        expect {
          post :create, :user => user_attributes
        }.to change(User, :count).by(1)
      end

      it "should response error when invalid attributes" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        expect {
          post :create, :user => user_attributes_invalid
          response.should render_template ["layouts/site", "new"]
        }.to_not change(User, :count)
      end

      it "should save birthday" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        ProfileBuilder.stub(:factory)
        post :create, :user => user_attributes
        controller.current_user.birthday.should eq(birthday_date)
      end

      it "should clear birthday session" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        ProfileBuilder.stub(:factory)
        post :create, :user => user_attributes
        session[:profile_birthday].should be_nil
      end

      it "should save questions" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        ProfileBuilder.should_receive(:factory)
        post :create, :user => user_attributes
      end

      it "should clear questions in session" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        ProfileBuilder.stub(:factory)
        post :create, :user => user_attributes
        session[:profile_questions].should be_nil
      end

      it "should redirect to welcome" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        ProfileBuilder.stub(:factory)
        post :create, :user => user_attributes
        response.should redirect_to(member_welcome_path)
      end

      it "should set registered_via from quiz" do
        session[:profile_questions] = :some_data
        session[:profile_birthday] = birthday
        ProfileBuilder.should_receive(:factory)
        post :create, :user => user_attributes
        controller.current_user.registered_via.should eq(User::RegisteredVia[:quiz])
      end
    end

    context "when is half user" do
      it "should save user" do
        expect {
          post :create_half, :user => half_user_attributes
        }.to change(User, :count).by(1)
      end

      it "should response error when invalid attributes" do
        expect {
          post :create_half, :user => half_user_attributes_invalid
          response.should render_template ["layouts/site", "half_user"]
        }.to_not change(User, :count)
      end

      it "should redirect to gift page when session is empty" do
        post :create_half, :user => half_user_attributes
        response.should redirect_to(gift_root_path)
      end

      context "with cart for gift in session" do
        let (:recipient) { FactoryGirl.create(:gift_recipient, :user => nil) }
        let (:occasion) { FactoryGirl.create(:gift_occasion, :user => nil, :gift_recipient => recipient) }
        let (:cart) { FactoryGirl.create(:cart_with_gift) }

        before  :each do
          session[:recipient_id] = recipient.id
          session[:occasion_id] = occasion.id
          session[:cart_id] = cart.id
        end

        it "should set registered_via from gift" do
          post :create_half, :user => half_user_attributes
          controller.current_user.registered_via.should eq(User::RegisteredVia[:gift])
        end

        it "should update gift occassion with user" do
          post :create_half, :user => half_user_attributes
          occasion.reload.user_id.should be(controller.current_user.id)
        end

        it "should update gift recipient with user" do
          post :create_half, :user => half_user_attributes
          recipient.reload.user_id.should be(controller.current_user.id)
        end

        it "should update cart with user" do
          post :create_half, :user => half_user_attributes
          cart.reload.user_id.should be(controller.current_user.id)
        end

        it "should redirect to address page" do
          post :create_half, :user => half_user_attributes
          response.should redirect_to(new_checkout_url(protocol: 'https'))
        end
      end

      context "with cart in session" do
        let (:cart) { FactoryGirl.create(:cart_with_items) }

        before  :each do
          session[:cart_id] = cart.id
        end

        it "should set registered_via from thin" do
          post :create_half, :user => half_user_attributes
          controller.current_user.registered_via.should eq(User::RegisteredVia[:thin])
        end

        it "should update cart with user" do
          post :create_half, :user => half_user_attributes
          cart.reload.user_id.should be(controller.current_user.id)
        end

        it "should redirect to address page" do
          post :create_half, :user => half_user_attributes
          response.should redirect_to(new_checkout_url(protocol: 'https'))
        end
      end
    end

    it "should save tracking" do
      session[:profile_questions] = :some_data
      session[:profile_birthday] = birthday
      session[:tracking_params] = "bla"
      ProfileBuilder.stub(:factory)
      expect {
        post :create, :user => user_attributes

        last_event = Event.last
        last_event.user_id.should be(controller.current_user.id)
        last_event.event_type.should be(EventType::TRACKING)
        last_event.description.should eq("bla")
      }.to change{Event.count}.by(2)
    end

    it "should save invite" do
      session[:profile_questions] = :some_data
      session[:profile_birthday] = birthday
      session[:invite] = {:invite_token => inviting_member.invite_token}
      ProfileBuilder.stub(:factory)
      post :create, :user => user_attributes.merge("cpf" => "44827455619")
      controller.current_user.is_invited.should be_true
    end

    it "should clear invite session" do
      session[:profile_questions] = :some_data
      session[:profile_birthday] = birthday
      session[:invite] = {:invite_token => inviting_member.invite_token}
      ProfileBuilder.stub(:factory)
      post :create, :user => user_attributes.merge("cpf" => "44827455619")
      session[:invite].should be_nil
    end

    it "should save facebook" do
      session["devise.facebook_data"] = facebook_data
      session[:profile_questions] = :some_data
      session[:profile_birthday] = birthday
      ProfileBuilder.stub(:factory)
      post :create, :user => user_attributes
      controller.current_user.uid.should eq("12876556")
      controller.current_user.first_name.should eq("Maria")
      controller.current_user.last_name.should eq("Alencar")
      controller.current_user.facebook_token.should eq("abc")
    end

    it "should clear facebook session" do
      session["devise.facebook_data"] = facebook_data
      session[:profile_questions] = :some_data
      session[:profile_birthday] = birthday
      ProfileBuilder.stub(:factory)
      post :create, :user => user_attributes
      session["devise.facebook_data"].should be_nil
    end
  end

  describe "PUT update" do
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "should update the user" do
      User.any_instance.should_receive(:update_attributes).with(user_attributes)
      put :update, :id => @user.id, :user => user_attributes
      response.should render_template ["layouts/my_account", "edit"]
    end

    it "should not update the old cpf" do
      @user.cpf = "42232096807"
      put :update, :id => @user.id, :user => user_attributes.merge("cpf" => "19762003691")
      @user.reload.cpf.should eq(@user.cpf)
      response.should render_template ["layouts/my_account", "edit"]
    end

    it "should update cpf if it's nil" do
      @user.cpf = nil
      cpf = "19762003691"
      put :update, :id => @user.id, :user => user_attributes.merge("cpf" => "19762003691")
      @user.reload.cpf.should eq(cpf)
      response.should render_template ["layouts/my_account", "edit"]
    end

    it "should render the edit template" do
      User.any_instance.stub(:update_attributes).and_return(false)
      put :update, :id => @user.id, :user => user_attributes
      response.should render_template ["layouts/my_account", "edit"]
    end
  end

  describe "DELETE destroy_facebook_account" do
    it "should destroy the facebook account removing the user uid and facebook_token" do
      user = FactoryGirl.create(:user)
      sign_in user
      User.any_instance.should_receive(:update_attributes).with(:facebook_token => nil, :uid => nil, :facebook_permissions => [])
      delete :destroy_facebook_account
    end
  end
end
