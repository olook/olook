class Admin::GiftOccasionTypesController < Admin::BaseController
  respond_to :html
  before_filter :load_gift_recipient_relations
  
  def index
    @gift_occasion_types = GiftOccasionType.all
    respond_with :admin, @gift_occasion_types
  end

  def show
    @gift_occasion_type = GiftOccasionType.find(params[:id])
    respond_with :admin, @gift_occasion_type
  end

  def new
    @gift_occasion_type = GiftOccasionType.new
    respond_with :admin, @gift_occasion_type
  end

  def edit
    @gift_occasion_type = GiftOccasionType.find(params[:id])
    respond_with :admin, @gift_occasion_type
  end

  def create
    @gift_occasion_type = GiftOccasionType.new(params[:gift_occasion_type])

    if @gift_occasion_type.save
      flash[:notice] = 'Gift occasion type was successfully created.'
    end

    respond_with :admin, @gift_occasion_type
  end

  def update
    @gift_occasion_type = GiftOccasionType.find(params[:id])

    if @gift_occasion_type.update_attributes(params[:gift_occasion_type])
      flash[:notice] = 'Gift occasion type was successfully updated.'
    end

    respond_with :admin, @gift_occasion_type
  end

  def destroy
    @gift_occasion_type = GiftOccasionType.find(params[:id])
    @gift_occasion_type.destroy
    respond_with :admin, @gift_occasion_type
  end  
  
  private
  
  def load_gift_recipient_relations
    @gift_recipient_relations = GiftRecipientRelation.order(:name)
  end
end
