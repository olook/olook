class Admin::PaymentsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  def index
    @search = Payment.search(params[:search])
    @payments = @search.relation.page(params[:page]).per_page(100).order('created_at desc')
  end

  def show
    @payment = Payment.find(params[:id])
    @credits = Credit.where(:id => @payment.credit_ids.split(',')).all if @payment.credit_ids
    respond_with :admin, @payment, @credits
  end
end
