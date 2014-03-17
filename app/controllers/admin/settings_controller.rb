#encoding: utf-8
class Admin::SettingsController < Admin::BaseController
  load_and_authorize_resource

  def show
    @settings = Setting.defaults.merge(Setting.all)
  end

  def create
    settings = params[:settings]
    settings.each do |key, value|

      value = convert_to_appropriate_object(value)

      Setting.send("#{key}=", value)
    end
    redirect_to :admin_settings, :notice => "Configurações atualizadas com successo"
  end

  private
    def convert_to_appropriate_object value

      value = Setting.is_range?(value) ? Setting.convert_to_range(value) : value

      if value == "true"
        value = true
      elsif value == "false"
        value = false
      end

      value
    end

end
