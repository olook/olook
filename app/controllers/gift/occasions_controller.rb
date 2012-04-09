class Gift::OccasionsController < ApplicationController
  def new
    @occasion = GiftOccasion.new

    # collections for selects
    @occasion_types = GiftOccasionType.all
    @recipient_relations = GiftRecipientRelation.all
    
    @day = params[:day] ? params[:day].to_i : Date.today
    @month = params[:month] ? params[:month].to_i : Date.today
  end

  def create
    @recipient = GiftRecipient.new(params[:recipient])
    @occasion = GiftOccasion.new(params[:occasion])
    
    @occasion.recipient = @recipient

    if @recipient.save && @occasion.save
      # saved
      
    else
      # errors
      
    end
  end

end
