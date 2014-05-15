class ModalController < ApplicationController
  layout false
  def show
    if ModalExhibitionPolicy.apply?(params["path"], cookies[:sm])
      set_modal_cookie if cookies[:sm].blank?
      render "modal/show"
    else
      render status: 401
    end
  end

  private
  def set_modal_cookie
    cookies[:sm] = 1
  end
end
