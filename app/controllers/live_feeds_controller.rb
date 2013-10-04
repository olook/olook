class LiveFeedsController < ApplicationController
  http_basic_authenticate_with name: "euroads", password: "olook123"

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

  def create
    livefeed = LiveFeed.new(params[:live_feed])
    
    if livefeed.save
      render json: {status: :created}.to_json
    else
      render json: {status: :bad_request, message: livefeed.errors.as_json}.to_json
    end
  end

end
