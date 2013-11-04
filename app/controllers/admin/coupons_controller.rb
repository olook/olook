class Admin::CouponsController < Admin::BaseController

  load_and_authorize_resource
  
  respond_to :html
  before_filter :load_coupon, :only => [:show, :edit, :update, :destroy]

  def index
    @search = Coupon.search(params[:search])
    @coupons = @search.relation.page(params[:page]).per_page(15).order('created_at desc')
  end

  def show
  end

  def new
    @coupon = Coupon.new
    load_form_vars
  end

  def create
    @coupon = Coupon.new(params[:coupon])
    if @coupon.save
      redirect_to admin_coupons_path, :notice => "Coupon was successfully created."
    else
      load_form_vars
      flash[:error] = 'A problem occurred while trying to create the coupon.'
      respond_with :admin, @coupon
    end
  end

  def edit
    load_form_vars
  end

  def update
    if @coupon.update_attributes(params[:coupon])
      redirect_to admin_coupons_path, :notice => "Coupon was successfully updated."
    else
      load_form_vars
      flash[:error] = "A problem occurred while trying to update the coupon."
      respond_with :admin, @coupon
    end
  end

  private

  def load_coupon
    @coupon = Coupon.find(params[:id])
  end

  def load_form_vars
    @promotion_actions = PromotionAction.all
    @promotion_rules = PromotionRule.all
    @action_parameter = ActionParameter.new
    3.times { @coupon.rule_parameters.build }
  end
end
