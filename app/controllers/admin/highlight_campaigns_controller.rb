class Admin::HighlightCampaignsController < Admin::BaseController
  include Admin::ApplicationHelper
  respond_to :html

  def index
    @highlight_campaigns = HighlightCampaign.all
  end

  def show
    @highlight_campaign = HighlightCampaign.find(params[:id])
  end

  def new
    @highlight_campaign = HighlightCampaign.new
  end

  def edit
    @highlight_campaign = HighlightCampaign.find(params[:id])
  end

  def create
    @highlight_campaign = HighlightCampaign.new(params[:highlight_campaign])
     hash_returned = @highlight_campaign.add_products(@highlight_campaign.product_ids)
    if @highlight_campaign.save
      redirect_to [:admin, @highlight_campaign], notice: "#{prepare_message hash_returned}"
    else
      render action: "new"
    end

  end

  def update
    @highlight_campaign = HighlightCampaign.find(params[:id])
    if @highlight_campaign.update_attributes(params[:highlight_campaign])
      redirect_to [:admin, @highlight_campaign], notice: ''
    else
      render action: "edit"
    end

  end

  def destroy
    @highlight_campaign = HighlightCampaign.find(params[:id])
    @highlight_campaign.destroy
    redirect_to admin_highlight_campaigns_url
  end
end
