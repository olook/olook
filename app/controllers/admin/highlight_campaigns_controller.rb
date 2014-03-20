class Admin::HighlightCampaignsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  def index
    @search = HighlightCampaign.newest.search(params[:search])
    @highlight_campaigns = @search.relation.page(params[:page]).per_page(50)
  end

  def show
    @highlight_campaign = HighlightCampaign.find(params[:id])
    @campaign_products = SearchEngine.new(product_id: @highlight_campaign.product_ids).with_limit(1000)
  end

  def new
    @highlight_campaign = HighlightCampaign.new
  end

  def edit
    @highlight_campaign = HighlightCampaign.find(params[:id])
  end

  def create
    @highlight_campaign = HighlightCampaign.new(params[:highlight_campaign])
    if @highlight_campaign.save
      redirect_to [:admin, @highlight_campaign], notice: "Campanha criada com sucesso"
    else
      render action: "new"
    end

  end

  def update
    @highlight_campaign = HighlightCampaign.find(params[:id])
    if @highlight_campaign.update_attributes(params[:highlight_campaign])
      redirect_to [:admin, @highlight_campaign], notice: 'Campanha alterada com sucesso'
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
