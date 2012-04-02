class Admin::Gift::RecipientRelationsController < Admin::BaseController
  respond_to :html
  def index
    @gift_recipient_relations = GiftRecipientRelation.all
    respond_with :admin, @gift_recipient_relations
  end

  def show
    @gift_recipient_relation = GiftRecipientRelation.find(params[:id])
    respond_with :admin, @gift_recipient_relation
  end

  def new
    @gift_recipient_relation = GiftRecipientRelation.new
    respond_with :admin, @gift_recipient_relation
  end

  def edit
    @gift_recipient_relation = GiftRecipientRelation.find(params[:id])
    respond_with :admin, @gift_recipient_relation
  end

  def create
    @gift_recipient_relation = GiftRecipientRelation.new(params[:gift_recipient_relation])

    if @gift_recipient_relation.save
      flash[:notice] = 'Gift recipient relation was successfully created.'
    end

    respond_with :admin, @gift_recipient_relation
  end

  def update
    @gift_recipient_relation = GiftRecipientRelation.find(params[:id])

    if @gift_recipient_relation.update_attributes(params[:gift_recipient_relation])
      flash[:notice] = 'Gift recipient relation was successfully updated.'
    end

    respond_with :admin, @gift_recipient_relation
  end

  def destroy
    @gift_recipient_relation = GiftRecipientRelation.find(params[:id])
    @gift_recipient_relation.destroy
    respond_with :admin, @gift_recipient_relation
  end  
end
