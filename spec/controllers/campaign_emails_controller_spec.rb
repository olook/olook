require 'spec_helper'

describe CampaignEmailsController do
	let(:campaign_email) { FactoryGirl.create(:campaign_email) }
	let(:user) { FactoryGirl.create(:user, email: campaign_email.email) }

	describe "GET #new" do
		let(:campaign_email) { mock(CampaignEmail) }

		it "instantiates a new CampaignEmail" do
			CampaignEmail.should_receive(:new).and_return(campaign_email)
			get :new    
			assigns(:campaign_email).should eq(campaign_email)
		end

		it "responds with success" do
			get :new    
			response.should be_success
		end
	end

	describe "POST #create" do
		context "when user's already registered" do
			before(:each) do
				User.should_receive(:find_by_email).with(campaign_email.email).and_return(user)
				post :create, :campaign_email => { email: campaign_email.email}
			end

			it "finds the user by its email and assigns it to @user" do
				assigns(:user).should eq(user)
			end

			it "redirects to login modal" do
				response.should redirect_to("/campaign_emails/#{user.id}/login")
			end
		end

		context "no user found" do
			let(:email) { "eu@teste.com" }

			before(:each) do
				User.should_receive(:find_by_email).with(email).and_return(nil)
				CampaignEmail.should_receive(:find_by_email).with(email).and_return(nil)
				CampaignEmail.should_receive(:create!).with(email: email).and_return(campaign_email)
				post :create, :campaign_email => { email: email }
			end

			it "creates a new CampaignEmail in the db" do
				assigns(:campaign_email).should eq(campaign_email)
			end

			it "redirects to successful email registration page" do				
				response.should redirect_to("/campaign_emails/#{campaign_email.id}")
			end

			context "when email is already registered" do
				before(:each) do
					User.should_receive(:find_by_email).with(email).and_return(nil)
					CampaignEmail.should_receive(:find_by_email).with(email).and_return(campaign_email)
					post :create, :campaign_email => { email: email }
				end

				it "finds a campaign email to pass to the redirect" do
					assigns(:campaign_email).should eq(campaign_email)
				end

				it "should redirect to the 'we remember you' page" do
					response.should redirect_to("/campaign_emails/#{campaign_email.id}/remembered")
				end
			end
		end
	end

	describe "GET #login" do
		before(:each) do
			User.should_receive(:find).with(user.id.to_s).and_return(user)
			get :login, id: user.id.to_s
		end

		it "responds with success" do
			response.should be_success
		end
	end

	describe "GET #show" do
		before(:each) do
			get :show, id: campaign_email.id
		end

		it "responds with success" do
			response.should be_success
		end
	end

end
