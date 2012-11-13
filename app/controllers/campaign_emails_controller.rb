class CampaignEmailsController < ApplicationController
	layout "campaign_emails"

	def new
		@campaign_email = CampaignEmail.new
	end

	def create
		if @user = User.find_by_email(params[:campaign_email][:email])
			redirect_to login_campaign_email_path @user
		else	
			# Using find_or_create here to prevent duplicates. 
			# If a user with this email wasn't found, the discount wasn't used yet anyway.
			# So let the new user continue
			@campaign_email = CampaignEmail.find_or_create_by_email(params[:campaign_email][:email]) 
			# Resque.enqueue(CampaignEmailNotificationWorker, self.id)
			redirect_to campaign_email_path(@campaign_email)
		end
	end

	def show
	end

	def login
		@user = User.find(params[:id])
	end
end
