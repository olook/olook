class Gift::OccasionsController < ApplicationController
  layout "gift"
  before_filter :load_collections_for_selects, :only => [:new, :new_with_data]

  def new
    @day, @month = Date.today
  end
  
  def new_with_data
    if occasion = params[:occasion]
      @name = occasion[:name]
      @day = occasion[:day].to_i 
      @month = occasion[:month].to_i
      @facebook_uid = occasion[:facebook_uid]
      @occasion_type_id = occasion[:occasion_type_id]
      @recipient_relation_id = occasion[:recipient_relation_id]
    end
    render "new"
  end

  def create
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
  
  private
  
  def load_collections_for_selects
    @occasion_types = GiftOccasionType.all
    @recipient_relations = GiftRecipientRelation.all
  end

end
