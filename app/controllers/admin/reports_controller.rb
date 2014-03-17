# -*- encoding : utf-8 -*-
class Admin::ReportsController < Admin::BaseController
  authorize_resource :class => false
  def new
  end

  def create
    start_date = params[:start_date]
    end_date = params[:end_date]
    @report = ClearSaleReport.new(start_date, end_date, current_admin)
    @report.schedule_generation
    redirect_to admin_path, notice: "O relatório será enviado para seu email em alguns minutos"
  end
end
