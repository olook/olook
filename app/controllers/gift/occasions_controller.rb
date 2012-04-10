class Gift::OccasionsController < ApplicationController
  layout "gift"

  def new
    # collections for selects
    @occasion_types = GiftOccasionType.all
    @recipient_relations = GiftRecipientRelation.all
    
    @day = params[:day] ? params[:day].to_i : Date.today
    @month = params[:month] ? params[:month].to_i : Date.today
  end

  def create
    #FIXME: if you are getting an error saying the route is wrong, please make sure the form is posting to /gift/occasions
    #FIXME: if you are getting an error related to string vs. integer association, please refer to the new/view, and add _id to the end of the gift_occasion_type and gift_recipient_relation fields.
    @recipient = GiftRecipient.new(params[:recipient].merge(:user_id => current_user ? current_user : nil))
    @occasion = GiftOccasion.new(params[:occasion].merge(:user_id => current_user ? current_user : nil, :gift_recipient_id => @recipient))
    
    if @recipient.save && @occasion.save
      # saved
      session[:recipient] = @recipient
      session[:occasion] = @occasion
      render json: {:occasion => @occasion, :recipient =>  @recipient}
      # redirect_to :gift/:quizz/:new
    else
      # errors
      render json: {:occasion => @occasion.errors, :recipient =>  @recipient.errors}
      # redirect_to :gift/:occasion/:new
    end
  end

end
