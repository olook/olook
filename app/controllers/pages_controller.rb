# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_filter :get_contact_infos, :only => [:contact, :send_contact]

  def contact
    @contact_form = ContactForm.new
  end

  def olookmovel
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

  def avc_campaign
    render :avc_campaign
  end

  def umanomuito
    render :um_ano_muito
  end

  def troca
    
  end

  private

  def get_contact_infos
    @contact_infos = ContactInformation.all
  end
end
