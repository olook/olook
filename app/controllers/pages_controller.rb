# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_filter :get_contact_infos, :only => [:contact, :send_contact]

  def contact
    @contact_form = ContactForm.new
  end

  def loyalty
    user_credits = @user.nil? ? nil : @user.user_credits_for(:loyalty_program)
    @presenter = LoyaltyPresenter.new(@user, user_credits)
  end

  def send_contact
    @contact_form = ContactForm.new(params[:contact_form])
    if @contact_form.save
      flash[:notice] = "Sua mensagem foi enviada com sucesso."
      redirect_to(contact_path)
    else
      render :contact
    end
  end

end

private

def get_contact_infos
  @contact_infos = ContactInformation.all
end

