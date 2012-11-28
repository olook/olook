# -*- encoding : utf-8 -*-
class Gift::ProfilesController < Gift::BaseController
  layout 'gift'

  def show
  	@profile 	= Profile.find_by_alternative_name( params[:name] )

  	finder = ProductFinderService.new(nil)
  	@products = finder.profile_products( profile: @profile )
    
    @helena_tips = GiftBox.find_by_name("Dica da Helena")
    @top_five = GiftBox.find_by_name("Top Five")
    @hot_on_facebook = GiftBox.find_by_name("Hot on Facebook")
  end

  def helena_tips
    @suggestion_products = GiftBox.find_by_name("Dica da Helena").suggestion_products
  end

  def top_five
    @suggestion_products = GiftBox.find_by_name("Top Five").suggestion_products
  end

  def hot_on_facebook
    @suggestion_products = GiftBox.find_by_name("Hot on Facebook").suggestion_products
  end

end