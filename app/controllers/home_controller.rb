# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  layout 'lite_application'

  def index
    @google_path_pixel_information = "Home"
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @recommendation = RecommendationService.new(profiles: current_user.try(:profiles_with_fallback) || [Profile.default])
    @looks = @recommendation.full_looks(limit: 4)

    @products = []
    categories = [
      Category::CLOTH,
      Category::SHOE,
      Category::BAG,
      Category::ACCESSORY
    ]
    products = categories.map do |category_id|
      @recommendation.products(category: category_id, limit: 18)
    end.flatten
    categories.cycle do |category_id|
      break if products.empty? || @products.size >= 18
      p = products.find { |_p| _p.category == category_id }
      if p
        @products.push(p)
        products.delete(p)
      end
    end

    prepare_for_home
  end

end
