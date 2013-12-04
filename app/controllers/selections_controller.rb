# -*- encoding : utf-8 -*-
class SelectionsController < OlookletController

  def index
    visibility = "1-2-3"
    search_params = SeoUrl.parse(request.fullpath).merge({visibility: visibility})
    Rails.logger.debug("New params: #{params.inspect}")
    default_params(search_params,"selections", "selections")
    render 'olooklet/index'
  end

  def header
    @header ||= CatalogHeader::CatalogBase.for_url("/" + params[:lbl]).first
  end


end