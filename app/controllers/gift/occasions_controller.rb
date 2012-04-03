class Gift::OccasionsController < ApplicationController
  def new
    @occasion = GiftOccasion.new

    # collections for selects
    @occasion_types = GiftOccasionTypes.all
    @recipient_relations = GiftRecipientRelations.all
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
