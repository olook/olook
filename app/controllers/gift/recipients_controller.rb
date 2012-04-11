class Gift::RecipientsController < Gift::BaseController
  # TO DO:
  # - check if user is logged in (we need an user_id to create the GiftRecipient)
  # - get shoe size (new and edit)
  # - give the option to change the profile_id in new and edit (combo box)
  # - redirect to suggestion page on success
  def new
    @recipient_profile = session[:recipient_profile]
  end

  def create
    redirect_to gift_root_path
  end

  def update
  end

  def edit
  end
end
