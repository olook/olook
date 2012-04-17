# -*- encoding : utf-8 -*-
class Gift::RecipientsController < Gift::BaseController
  # TO DO:
  # - hide recipient id (in session or via post)
  # - make route to post to edit action
  before_filter :load_recipient

  def edit
    profile_id = params[:gift_recipient][:profile_id] if params.include?(:gift_recipient)
    @profiles = @gift_recipient.ranked_profiles(profile_id)
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
