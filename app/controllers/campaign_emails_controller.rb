class CampaignEmailsController < ApplicationController
  layout "campaign_emails"

  def new
    @campaign_email = CampaignEmail.new
  end

  def create
    if @user = User.find_by_email(params[:campaign_email][:email])
      redirect_to login_campaign_email_path @user
    else
      if @campaign_email = CampaignEmail.find_by_email(params[:campaign_email][:email])
        redirect_to remembered_campaign_email_path(@campaign_email)
      elsif @campaign_email = CampaignEmail.create!(email: params[:campaign_email][:email])
        @campaign_email.set_utm_info session[:tracking_params]
        redirect_to campaign_email_path(@campaign_email)
      end
    end
  end

  def login
      @user = User.find(params[:id])
  end

  def show; end

  def remembered; end

end
