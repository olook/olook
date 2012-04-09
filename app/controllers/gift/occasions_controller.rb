class Gift::OccasionsController < ApplicationController
  def new
    @occasion = GiftOccasion.new

    # collections for selects
    @occasion_types = GiftOccasionType.all
    @recipient_relations = GiftRecipientRelation.all
  end

  def create
    @recipient = GiftRecipient.new(params[:recipient])
    
    @occasion = GiftOccasion.new(params[:occasion])
    @occasion.recipient = @recipient

    if @recipient.save && @goccasion.save
      # saved

    else
      # errors

    end
  end

end
