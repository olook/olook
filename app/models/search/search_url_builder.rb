class SearchUrlBuilder
  SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
  BASE_URL = SEARCH_CONFIG["search_domain"]

  def initialize term
    @term = term
  end

  def build_url_with attributes={}
    query = "q=#{CGI.escape @term}"
    query += "&bq=categoria%3A'#{CGI.escape attributes[:category]}'" if attributes[:category]
    query += "&bq=brand%3A'#{CGI.escape attributes[:brand]}'" if attributes[:brand]
    query += "&size=100"
    query += "&rank=-#{attributes[:rank]}" if attributes[:rank]
    URI.parse("http://#{BASE_URL}/2011-02-01/search?#{query}&return-fields=categoria,name,brand,description,image,price,backside_image,category,text_relevance")
  end

end
