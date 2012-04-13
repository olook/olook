# encoding: UTF-8
class Gift::OccasionsController < Gift::BaseController
  before_filter :load_collections_for_selects, :only => [:new, :new_with_data]
  
  def new
    @day = @month = Date.today
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
    render :new
  end

  def create
    @occasion = GiftOccasion.new(params[:occasion].merge(:user_id => current_user ? current_user : nil))
    @occasion.build_gift_recipient(params[:recipient].merge(:user_id => current_user ? current_user : nil))
    
    if @occasion.save
      # saved
      session[:occasion_id] = @occasion.id
      session[:recipient_id] = @occasion.gift_recipient.id
      
      redirect_to new_gift_survey_path
    else
      # errors
      flash[:notice] = "Não foi possível criar o seu presente, verifique os dados e tente novamente." if @occasion.errors.any?
      redirect_to :back
    end
  end
  
  private
  
  def load_collections_for_selects
    @occasion_types = GiftOccasionType.all
    @recipient_relations = GiftRecipientRelation.all
  end

end
