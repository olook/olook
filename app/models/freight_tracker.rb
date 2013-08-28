module FreightTracker

  def track_zip_code_fetch_event(zip_code=params[:id])
    track_event(EventType::ZIP_CODE_FETCHED, zip_code)
  end  

  def track_finished_checkout(zip_code=params[:id])
    track_event(EventType::FINISHED_CHECKOUT, zip_code)
  end  

  private 
    def track_event(type, zip_code)
      if current_user
        freight_table = params[:freight_service_ids].blank? ? 'A' : 'B'
        current_user.add_event(type, {zip_code: zip_code, freight_table: freight_table})
      end      
    end


end