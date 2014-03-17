class Admin::HolidaysController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  def index
    @holidays = Holiday.page(params[:page]).per_page(15).order('event_date desc')
    respond_with :admin, @holiday
  end

  def show
    @holiday = Holiday.find(params[:id])
    respond_with :admin, @holiday
  end

  def new
    @holiday = Holiday.new
    respond_with :admin, @holiday
  end

  def edit
    @holiday = Holiday.find(params[:id])
    respond_with :admin, @holiday
  end

  def create
    @holiday = Holiday.new(params[:holiday])

    flash[:notice] = 'Feriado criado com sucesso.' if @holiday.save
    respond_with :admin, @holiday
  end

  def update
    @holiday = Holiday.find(params[:id])

    flash[:notice] = 'Feriado atualizado com sucesso.' if @holiday.update_attributes(params[:holiday])
    respond_with :admin, @holiday
  end

  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy
    respond_with :admin, @holiday
  end
end
