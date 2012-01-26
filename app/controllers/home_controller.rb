# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  before_filter :redirect_logged_user, :save_tracking_params, :only => :index

  def index
    if params[:share]
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

  def redirect_logged_user
    redirect_to(member_showroom_path) if user_signed_in?
  end
  
  def save_tracking_params
    incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }

    if !incoming_params.empty?
      session[:tracking_params] = incoming_params
    end
  end
end
