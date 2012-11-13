class Admin::CampaignsController < Admin::BaseController
  respond_to :html

  def index
    @search = Campaign.search(params[:search])
    @campaigns = @search.relation.page(params[:page]).per_page(100)
  end

  def show
  end

  def new
    @campaign = Campaign.new
    respond_with :campaign, @campaign
  end

  def edit
  end
end
