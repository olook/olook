class ModalController < ApplicationController
  layout false
  def show
    if ModalExhibitionPolicy.apply?(params["path"], cookies[:sm])
      set_modal_cookie if cookies[:sm].blank?
      variation = ab_test('modal', 'modal1', 'modal2') 
      render "modal/show1" if variation == 'modal1'
      render "modal/show2" if variation == 'modal2'
    else
      render status: 401
    end
  end

  private
  def set_modal_cookie
    cookies[:sm] = 1
  end
end
