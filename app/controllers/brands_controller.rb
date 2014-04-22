class BrandsController < ApplicationController
  layout "lite_application"
  def index
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/marcas/:brand:/-:category::subcategory:-/-:care::color::size::heel:_')
    @search = SearchEngine.new
    @url_builder.set_search @search
    @brands = separate_brands_by_capital_letter(ActiveSupport::JSON.decode(REDIS.get("sitemap"))["brands"])
  end

  def show
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/marcas/:brand:/-:category::subcategory:-/-:care::color::size::heel:_')
    search_params = @url_builder.parse_params
    if search_params['category'] == 'roupa'
      @url_builder.set_params('category', 'roupa')
    end
    @campaign = HighlightCampaign.find_campaign(params[:cmp])
    @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(48)
    @search.for_admin if current_admin
    @url_builder.set_search @search
    redirect_to brand_not_found_path if @search.products.size == 0
    @color = search_params["color"]
    @size = search_params["size"]
    @brand = Brand.where(name:  params[:brand].to_s.split("-").map{|brand| ActiveSupport::Inflector.transliterate(brand).downcase.titleize})
    @brand_name = @brand.first.try(:name)
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
  end

  def not_found
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/marcas/:brand:/-:category::subcategory:-/-:care::color::size::heel:_')
    search_params = @url_builder.parse_params
    @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(48)
    @brand = Brand.where(name:  params[:brand].to_s.split("-").map{|brand| ActiveSupport::Inflector.transliterate(brand).downcase.titleize})
  end
  private
    def canonical_link
      brand = Array(@brand).first
      if brand
        "http://#{request.host_with_port}/#{brand.name.downcase}"
      end
    end

    def separate_brands_by_capital_letter brands
      response = {}

      brands.each do |b|
        index = (b[0] =~ /[A-Z]/i) ? b[0].upcase : "0-9"
        response[index] ||= []
        response[index] << b
        response[index].sort!
      end
      response
    end
    
end
