# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  before_filter :authenticate_user!, :only => [:welcome]
  before_filter :load_order
  before_filter :get_contact_infos, :only => [:contact, :send_contact]

  def welcome
    @redirect_uri = welcome_path
    @member = current_user
  end

  def contact
    @contact_form = ContactForm.new
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

  def share
    @user = User.find(params[:uid])
    @profile = @user.profile_scores.first.try(:profile).first_visit_banner
    profiles = {
                  "casual" => 'Prática, Despojada, Independente, e adoto o lema "menos é mais"',
                  "conteporanea" => 'Antenada, Criativa, Confiante e AMO moda',
                  "elegant" => 'Chic, Bem Sucedida, Elegante e Exigente',
                  "feminine" => 'Vaidosa, Romântica, Alegre e Delicada',
                  "sexy" => 'Sexy, Extravagante, Segura e Vivaz',
                  "traditional" => 'Sofisticada, Conservadora, Discreta e Clássica',
                  "trendy" => 'Segura, Ousada, Sexy e Moderna' 
                } 
    @qualities = profiles["#{@profile}"]
    @url = request.protocol + request.host 
  end
end

private

def get_contact_infos
  @contact_infos = ContactInformation.all
end

