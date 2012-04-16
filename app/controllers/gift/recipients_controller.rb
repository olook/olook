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
    profile_and_shoe = params[:gift_recipient].slice(:shoe_size, :profile_id) if params.include?(:gift_recipient)
    if profile_and_shoe && profile_and_shoe[:shoe_size].present?
      @gift_recipient.update_attributes!(profile_and_shoe) if @gift_recipient.belongs_to_user?(current_user)
      redirect_to gift_suggestions_path
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
