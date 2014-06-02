#encoding: utf-8
class Admin::MktSettingsController < Admin::BaseController
  load_and_authorize_resource

  def show
    @settings = MktSetting.all
  end

  def create
    settings = params[:settings]
    settings.each do |key, value|
      MktSetting.send("#{key}=", value)
    end if settings
    redirect_to :admin_mkt_settings, :notice => "Configurações atualizadas com successo"
  end
end
