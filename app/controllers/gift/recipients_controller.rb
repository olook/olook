# -*- encoding : utf-8 -*-
class Gift::RecipientsController < Gift::BaseController
  before_filter :load_recipient

  def edit
    profile_id = params[:gift_recipient][:profile_id] if params.include?(:gift_recipient)
    @profiles = @gift_recipient.ranked_profiles(profile_id)
    @main_profile = profile_id ? @profiles.first : (@gift_recipient.try(:profile) || @profiles.first)
  end

  def update
    if @gift_recipient.update_attributes(profile_and_shoe)
      redirect_to gift_recipient_suggestions_path(@gift_recipient)
    else
      flash[:notice] = "Por favor, escolha o número de sapato da sua presenteada."
      redirect_to edit_gift_recipient_path(@gift_recipient)
    end
  end
  
  private

  def load_recipient
    @gift_recipient = GiftRecipient.find(params[:id])
  end

  def profile_and_shoe
    params[:gift_recipient].slice(:shoe_size, :profile_id) if params.include?(:gift_recipient)
  end

end
