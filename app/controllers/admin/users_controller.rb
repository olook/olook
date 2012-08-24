# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::BaseController

  load_and_authorize_resource
  before_filter :check_params_for_create_credits, :only => :create_credit_transaction
  respond_to :html, :js, :text

  def index
    @search = User.search(params[:search])
    @users = @search.relation.page(params[:page]).per_page(15).order('created_at desc')
  end

  def show
    @user = User.find(params[:id])
    # survey_answers_parser = SurveyAnswerParser.new(@user.survey_answers)
    # @survey_answers = survey_answers_parser.build_survey_answers
    @redeem_credits = @user.user_credits_for(:redeem).credits
    @loyalty_program_credits = @user.user_credits_for(:loyalty_program).credits
    @invite_credits = @user.user_credits_for(:invite).credits
    respond_with :admin, @user
  end

  def edit
    @user = User.find(params[:id])
    respond_with :admin, @user
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with :admin, @user
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
    end
    respond_with :admin, @user
  end

  def statistics
    @statistics = UserReport.statistics
    respond_with :admin, @statistics
  end

  def export
    Resque.enqueue(Admin::ExportUsersWorker, current_admin.email)
  end

  def admin_login
    if sign_in User.find(params[:id]), :bypass => true
      session[:cart_id] = Cart.includes(:orders).where(:orders => {:id => nil}, :user_id => params[:id]).last.try(:id)
      session[:gift_wrap] = nil
      session[:cart_coupon] = nil
      session[:cart_credits] = nil
      session[:cart_freight] = nil
      redirect_to(member_showroom_path) 
    end
  end

  def lock_access
    @user = User.find(params[:id])
    @user.lock_access!
    redirect_to :action => :show
  end

  def unlock_access
    @user = User.find(params[:id])
    if @user.access_locked?
      @user.unlock_access!
    end
    redirect_to :action => :show
  end

  def create_credit_transaction
    @user.user_credits_for(@credit_type).send(params[:method],
      admin_id: current_admin.id,
      amount: @amount,
      order: @order,
      reason: @reason,
      source: "#{params[:method]} by #{current_admin.name}",
      user: @user
    )

    redirect_to(admin_user_path(@user), :notice => 'Crédito adicionado com sucesso!')
  end

  private
  def check_params_for_create_credits
    @user = User.find(params[:id])
    @amount = BigDecimal.new(params[:value].to_s)
    @reason, @credit_type, @has_order = params[:reason], *params[:operation].split(":")
     
    @order = Order.find_by_number(params[:ordem_number])

    raise NoMethodError.new("Invalid method #{params[:method]}.") unless ['add','remove'].include?(params[:method])
    return redirect_with_notice("Ordem não foi encontrada. Verifique se o número da ordem está correto.") if @has_order and @order.nil?
    return redirect_with_notice("O valor de crédito não permitido") if amount_is_valid?(@amount, @credit_type)
  end

  def amount_is_valid?(amount, credit_type)
    amount <= 0.0 or (credit_type == "invite" and amount > UserCredit::INVITE_BONUS) or (amount > UserCredit::TRANSACTION_LIMIT)
  end

  def redirect_with_notice(notice)
    redirect_to(admin_user_path(@user, {
                                          value: params[:value], 
                                          order_number: params[:ordem_number], 
                                          operation: params[:operation],
                                          reason: params[:reason],
                                          method: :add
                                        }), :notice => notice)
  end
end
