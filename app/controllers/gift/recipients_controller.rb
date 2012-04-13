# -*- encoding : utf-8 -*-
class Gift::RecipientsController < Gift::BaseController
  # TO DO:
  # - check if current_user.id is equal to gift_recipient.user_id (if user is loged in)
  # - hide recipient id (in session or via post)
  before_filter :load_recipient

  def edit
    profiles = session[:recipient_profiles]
    if profiles.present?
      @profiles = Profile.find(*profiles)
      @gift_recipient.update_attributes!(:profile => @profiles.first) unless @gift_recipient.profile
    else
      @profiles = Profile.all
    end
  end

  def update
    both_params = params[:gift_recipient].slice(:shoe_size, :profile_id) if params.include?(:gift_recipient)
    if both_params && both_params[:shoe_size].present?
      @gift_recipient.update_attributes!(both_params)
      redirect_to gift_root_path
    else
      flash[:notice] = "Por favor, escolha o número de sapato da sua presenteada."
      redirect_to edit_gift_recipient_path(@gift_recipient)
    end
  end

  private

  def load_recipient
    @gift_recipient = GiftRecipient.find(params[:id])
  end
end
