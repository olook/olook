class Gift::HomeController < Gift::BaseController  
  def index
  end
  
  def update_birthdays_by_month
    @friends = @facebook_adapter.facebook_friends_with_birthday(params[:month]) if @facebook_adapter
  end

end
