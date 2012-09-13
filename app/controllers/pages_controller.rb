# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_filter :get_contact_infos, :only => [:contact, :send_contact]

  def contact
    @contact_form = ContactForm.new
  end

  def loyalty
    @next_month = (Time.now + 1.month).at_beginning_of_month
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

