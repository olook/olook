# -*- encoding : utf-8 -*-
class Admin::ItinerariesController < Admin::BaseController

  load_and_authorize_resource
  respond_to :html

  def index
    begin
      @itinerary = Itinerary.olookmovel
      redirect_to edit_admin_itinerary_path(@itinerary)
    rescue ActiveRecord::RecordNotFound
      @itineraries = Itinerary.all
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    respond_with :admin, @itinerary
  end

  def new
    @itinerary = Itinerary.new
    respond_with :admin, @itinerary
  end


  def edit
    @itinerary = Itinerary.find(params[:id])
    respond_with :admin, @itinerary
  end

  def create
    @itinerary = Itinerary.new(params[:itinerary])

    if @itinerary.save
      redirect_to [:admin, @itinerary], notice: 'Itinerário criado com sucesso.'
    else
      render action: "new"
    end
  end

  def update
    itinerary = Itinerary.find(params[:id])

    if itinerary.update_attributes(params[:itinerary])
      redirect_to edit_admin_itinerary_path(itinerary), notice: 'Itinerário atualizado com sucesso.'
    else
      render action: "edit" 
    end
  end

  def destroy
    @itinerary = Itinerary.find(params[:id])
    @itinerary.destroy

    redirect_to admin_itineraries_url
  end
end
