# -*- encoding : utf-8 -*-
class Admin::PromotionsController < Admin::BaseController
  load_and_authorize_resource

  respond_to :html

  def index
    @promotions = Promotion.all
    respond_with @promotions
  end

  def show
    @promotion = Promotion.find(params[:id])
    respond_with @promotion
  end

  def new
    @promotion_actions = PromotionAction.all
    @promotion_rules = PromotionRule.all
    @promotion = Promotion.new
    @action_parameter = ActionParameter.new
    @promotion.rule_parameters.build
  end

  def edit
    @promotion_actions = PromotionAction.all
    @promotion_rules = PromotionRule.all
    @promotion = Promotion.find(params[:id])
    @promotion.rule_parameters.build
    @action_parameter = @promotion.action_parameter ? @promotion.action_parameter : ActionParameter.new
  end

  def create
    @promotion = Promotion.new(params[:promotion])
    if @promotion.save
      flash[:notice] = 'Promotion was successfully created.'
    else
      @promotion.rule_parameters.build
      @action_parameter = @promotion.action_parameter ? @promotion.action_parameter : ActionParameter.new
      @promotion_actions = PromotionAction.all
      @promotion_rules = PromotionRule.all
    end
    respond_with :admin, @promotion
  end

  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update_attributes(params[:promotion])
      flash[:notice] = 'Promotion was successfully updated.'
    else
      @promotion_actions = PromotionAction.all
      @promotion_rules = PromotionRule.all
    end
    respond_with :admin, @promotion
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    @promotion.destroy
    flash[:notice] = "Successfully destroy promotion"
    respond_with :admin, @promotion
  end
end
