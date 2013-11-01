class CampaignEmailsController < ApplicationController
  layout "campaign_emails"
  respond_to :html, :js

  def new
    @campaign_text = 6# @cart.coupon.try(:modal) || 1
    @campaign_email = @campaign_email || CampaignEmail.new
  end

  def create
    if @user = User.find_by_email(params[:campaign_email][:email])
      if params["ab_t"].present?
        choose_redirect_for_survey
      else
        redirect_to login_campaign_email_path @user
      end
    else
      if @campaign_email = CampaignEmail.find_by_email(params[:campaign_email][:email])
        redirect_path =  remembered_campaign_email_path(@campaign_email)
      elsif @campaign_email = CampaignEmail.create!(email: params[:campaign_email][:email])
        @campaign_email.set_utm_info session[:tracking_params]
        redirect_path = campaign_email_path(@campaign_email)
      end
      cookies['newsletterUser'] = { value: '1', path: '/', expires: 30.years.from_now }
      cookies['ceid'] = { value: "#{@campaign_email.id}", path: '/', expires: 30.years.from_now }
      cookies['newsletterEmail'] = { value: params[:campaign_email][:email], path: '/', expires: 10.minutes.from_now }

      if params["ab_t"].present?
        choose_redirect_for_survey
      elsif params[:campaign_email][:from_footer].present?
        respond_to :js
      else
        redirect_to redirect_path
      end
    end
  end

  def subscribe
    email = params[:email]

    @campaign_email = CampaignEmail.new(email: params[:email])
    if @campaign_email.save
      status = "ok"
      message = "NewsLetter ja cadastrado"
    else
      status = "error"
      message = "Usuario ja cadastrado"
    end
    render json: {status: status, message: message}.to_json
  end

  def login
    @user = User.find(params[:id])
  end

  def show
    @campaign_email = CampaignEmail.find(params[:id])
  end

  def remembered
    @campaign_email = CampaignEmail.find(params[:id])
  end

  private

    def choose_redirect_for_survey
      if @user = User.find_by_email(params[:campaign_email][:email])
        redirect_to new_user_session_path
      else
        redirect_to wysquiz_path
      end
    end

end
