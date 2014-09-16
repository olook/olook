class SearchRedirectService
  KEY_WORDS = ["olook-movel", "kombi-olook", "kombi", "show-room-olook"]	
  
  def initialize(search_params)
    @search = search_params
  end

  def path
    return false if @search == nil
  	Rails.application.routes.url_helpers.olookmovel_path if should_redirect?
  end

  private
  def should_redirect?
    KEY_WORDS.include?(@search.parameterize)
  end
end