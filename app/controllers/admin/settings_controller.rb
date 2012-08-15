#encoding: utf-8
class Admin::SettingsController < Admin::BaseController
  load_and_authorize_resource
  
  def show
    @settings = Setting.all
  end

  def create
    settings = params[:settings]
    settings.each do |key, value|
      if value == "true"
        value = true
      elsif value == "false"
        value = false
      end
      Setting.send("#{key}=", value)
    end
    redirect_to :admin_settings, :notice => "Configurações atualizadas com successo"
  end
end
