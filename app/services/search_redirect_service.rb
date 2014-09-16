class SearchRedirectService
  KEY_WORDS = ["olook-movel", "kombi-olook", "kombi", "show-room-olook"]	
  
  def initialize(search_params)
    @search = search_params
  end

  def should_redirect?
    return false if @search == nil
  	KEY_WORDS.include?(@search.parameterize)
  end

  def path
  	Rails.application.routes.url_helpers.olookmovel_path if should_redirect?
  end
end