class Admin::UtilitiesController < Admin::BaseController
  respond_to :html

  def index
  end

  def restart_resque_workers
    `/usr/bin/restart_resque_workers`
    redirect_to(admin_utilities_path, :notice => "Os workers do resque foram reiniciados com sucesso!")
  end

  def invalidates_cdn_content
    path = params[:cdn_path]
    CloudfrontInvalidator.new.invalidate(path)
    redirect_to(admin_utilities_path, :notice => "#{path} foi invalidado com sucesso!")
  end
end
