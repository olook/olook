class SearchController < ApplicationController
  respond_to :json

  def index

  
  end

  def show
  # url = "?q=#{params[:q]}&return-fields=categoria,name,description,text_relevance"
    url = URI.parse("http://busca.olook.com.br/2011-02-01/search?q=#{params[:q]}&return-fields=categoria,name,description,text_relevance")
    response = Net::HTTP.get_response(url)

    @hits = JSON.parse(response.body)["hits"]

  end


end
