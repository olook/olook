# -*- encoding : utf-8 -*-
class Gift::RecipientsController < Gift::BaseController
  # TO DO:
  # - check if current_user.id is equal to gift_recipient.user_id
  before_filter :load_recipient

  def edit
    profiles = session[:recipient_profiles]
    if profiles.present?
      @profiles = Profile.find(*profiles)
      @gift_recipient.update_attributes!(:profile => @profiles.first) unless @gift_recipient.profile
    else
      redirect_to gift_root_path
    end
  end

  def update
    shoe_size_and_profile = params[:gift_recipient].slice(:shoe_size, :profile_id) if params[:gift_recipient].present?
    @gift_recipient.update_attributes!(shoe_size_and_profile) if shoe_size_and_profile
    redirect_to gift_root_path
  end

  private

  def load_recipient
    @gift_recipient = GiftRecipient.find(params[:id])
  end
end
