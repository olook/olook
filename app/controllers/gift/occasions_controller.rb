class Gift::OccasionsController < ApplicationController
  def new
    @occasion = GiftOccasion.new

    # collections for selects
    @occasion_types = GiftOccasionType.all
    @recipient_relations = GiftRecipientRelation.all
  end

  def create
    @occasion = GiftOccasion.new(params[:occasion])

    if @goccasion.save
      # saved

    else
      # errors

    end
  end

end
