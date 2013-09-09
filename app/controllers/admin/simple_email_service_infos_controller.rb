class Admin::SimpleEmailServiceInfosController < Admin::BaseController
  def index

  end
  def show
    start_at = params[:start_at]
    end_at = params[:ends_at]
    @email_info = SimpleEmailServiceInfo.info(Date.new(start_at[:year].to_i,start_at[:month].to_i,start_at[:day].to_i), Date.new(end_at[:year].to_i,end_at[:month].to_i,end_at[:day].to_i))
  end
end
