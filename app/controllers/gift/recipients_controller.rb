class Gift::RecipientsController < Gift::BaseController
  # TO DO:
  # - check if user is logged in
  # - get shoe size
  # - give the option to change the profile_id in new and edit
  # - redirect to suggestion page on success
  def new
    profiles = session[:recipient_profiles]
    if profiles.present?
      @profiles = Profile.find(*profiles)
      @gift_recipient = GiftRecipient.update_profile_and_shoe_size(session[:recipient_id], @profiles.first)
    else
      redirect_to gift_root_path
    end
  end

  def create
    #update profile and shoe size
    redirect_to gift_root_path
  end

  def update
  end

  def edit
  end
end
