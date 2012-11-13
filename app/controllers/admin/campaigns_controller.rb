class Admin::CampaignsController < Admin::BaseController
  respond_to :html

  def index
    @search = Campaign.search(params[:search])
    @campaigns = @search.relation.page(params[:page]).per_page(100)
  end

  def show
    @campaign = Campaign.find(params[:id])
    respond_with :campaign, @campaign
  end

  def new
    @campaign = Campaign.new
    respond_with :campaign, @campaign
  end

  def edit
    @campaign = Campaign.find(params[:id])
    respond_with :campaign, @campaign
  end
end
