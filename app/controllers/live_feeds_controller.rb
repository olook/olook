class LiveFeedsController < ApplicationController
  # Skip all before filters 
  skip_before_filter :load_user,
                      :create_cart,
                      :load_cart,
                      :load_coupon,
                      :load_cart_service,
                      :load_facebook_api,
                      :load_referer,
                      :load_tracking_parameters,
                      :set_modal_show,
                      :load_campaign_email_if_user_is_not_logged

  respond_to :json

  #
  # Os caras da EURO ADs nao conseguem fazer um POST :(
  #
  def index
    create
  end

  def create
    live_feed_params = extract_parameters
    livefeed = LiveFeed.new(live_feed_params)
    
    if livefeed.save
      render json: {feed: livefeed}, status: :created
    else
      render json: {message: livefeed.errors}, status: :bad_request
    end
  end

  # Necessario para o create funcionar via GET
  def extract_parameters
    params.reject{|key, value| ["action", "controller"].include?(key) }
  end

end
