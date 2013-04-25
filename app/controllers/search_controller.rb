class SearchController < ApplicationController
  respond_to :html

  def index

  end

  def show
    #url = URI.parse("http://search-olook-products-m7cmewyo4k3ih7na2nzixh5jae.us-east-1.cloudsearch.amazonaws.com/2011-02-01/search?q=#{CGI.escape params[:q]}&return-fields=categoria,name,description,image,price,text_relevance")
    url = URI.parse("http://busca.olook.com.br/2011-02-01/search?q=#{CGI.escape params[:q]}&return-fields=categoria,name,description,image,price,text_relevance")
    response = Net::HTTP.get_response(url)

    @hits = JSON.parse(response.body)["hits"]  

    #### PROTOTYPE

    @products = @hits["hit"].map do |hit| 
      OpenStruct.new(catalog_image: hit["data"]["image"][0], formatted_name: hit["data"]["name"][0], model_name: hit["data"]["categoria"][0], price: BigDecimal.new(hit["data"]["price"][0]), promotion?: false, id: hit["id"].to_i, )
    end

    #####END

  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

end
