# -*- encoding : utf-8 -*-
class HomeController < ApplicationController
  def index
    @google_path_pixel_information = "Home"
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    recommendation = RecommendationService.new(profiles: current_user.try(:profiles_with_fallback) || [Profile.default])
    @showroom_presenter = ShowroomPresenter.new(recommendation: recommendation, looks_limit: 4, products_limit: 22)
    prepare_for_home
  end

  private

  def prepare_for_home
    prepare_highlights

    if params[:share]
      @user = User.find(params[:uid])
      @profile = @user.profile_scores.first.try(:profile).try(:first_visit_banner)
      @qualities = Profile::DESCRIPTION["#{@profile}"]
      @url = request.protocol + request.host
    end
    @incoming_params = params.clone.delete_if {|key| ['controller', 'action'].include?(key) }
    session[:tracking_params] ||= @incoming_params
  end

  def prepare_highlights
    highlights = Highlight.highlights_to_show
    @left_highlight = highlights[HighlightPosition::LEFT]
    @center_highlight = highlights[HighlightPosition::CENTER]
    @right_highlight = highlights[HighlightPosition::RIGHT]
  end

end
