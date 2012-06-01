# encoding: UTF-8
class Gift::OccasionsController < Gift::BaseController
  before_filter :load_params, :only => [:new, :create]
  before_filter :load_collections_for_selects, :only => [:new, :new_with_data, :create]
  
  def new
    @day ||= @month ||= Date.today
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
    @occasion = GiftOccasion.new(params[:occasion].merge(:user_id => current_user.try(:id)))
    @occasion.build_gift_recipient(params[:recipient].merge(:user_id => current_user.try(:id)))
    
    if @occasion.save
      session[:occasion_id] = @occasion.id
      session[:recipient_id] = @occasion.gift_recipient.id
      
      redirect_to new_gift_survey_path
    else
      flash[:notice] = "Não foi possível criar o seu presente, verifique os dados e tente novamente."
      render :new
    end
  end
  
  private
  
  def load_collections_for_selects
    @occasion_types = GiftOccasionType.ordered_by_name
    @recipient_relations = GiftRecipientRelation.ordered_by_name
  end
  
  def load_params
    if occasion_type = params[:ot]
      occasion = GiftOccasionType.find(occasion_type)
      @day = occasion.day
      @month = occasion.month
      @occasion_type_id = occasion.id
      @recipient_relation_id = occasion.gift_recipient_relation_id
    else
      recipient, occasion = params[:recipient], params[:occasion]
      if occasion
        @day = occasion[:day].to_i
        @month = occasion[:month].to_i
        @occasion_type_id = occasion[:gift_occasion_type_id]
      end
      if recipient
        @name = recipient[:name]
        @facebook_uid = recipient[:facebook_uid]
        @recipient_relation_id = recipient[:gift_recipient_relation_id]
      end      
    end
  end

end
