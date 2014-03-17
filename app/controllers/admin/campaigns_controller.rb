class Admin::CampaignsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  def index
    @search = Campaign.search(params[:search])
    @campaigns = @search.relation.page(params[:page]).per_page(100)
  end

  def show
    @campaign = Campaign.find(params[:id])
    respond_with :admin, @campaign
  end

  def new
    @campaign = Campaign.new
    respond_with :admin, @campaign
  end

  def edit
    @campaign = Campaign.find(params[:id])
    respond_with :admin, @campaign
  end

  def create
    @campaign = Campaign.new(params[:campaign])

    flash[:notice] = 'Campaign was successfully created.' if @campaign.save
    respond_with :admin, @campaign
  end

  def update
    @campaign = Campaign.find(params[:id])

    flash[:notice] = 'Campaign was successfully updated.' if @campaign.update_attributes(params[:campaign])
    respond_with :admin,@campaign
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    respond_with :admin, @campaign
  end
end
