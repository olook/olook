class ModalController < ApplicationController
  layout false
  def show

    if ModalExhibitionPolicy.apply?(path: params["path"], cookie: cookies[:sm], user: current_user)
      set_modal_cookie if cookies[:sm].blank?
      variation = ab_test('acquisition_popup_test', 'facebook', 'email')
      if variation == 'facebook'
        render json: {html: render_to_string(partial: 'show1.html.erb'), name: variation, width: "504",height: "610", color: "#fff" }
      else
        render json: {html: render_to_string(partial: 'show2.html.erb'), name: variation, width: "504",height: "610", color: "#fff" }
      end
    else
      render text: "",status: 401
    end
  end

  private
  def set_modal_cookie
    cookies[:sm] = {
       :value => "1",
       :expires => 1.day.from_now
     }
  end
end
