class ModalController < ApplicationController
  layout false
  def show
    increment if cookies[:sm]
    if ModalExhibitionPolicy.apply?(path: params["path"], cookie: cookies[:sm], user: current_user, mobile: mobile?)
      set if cookies[:sm].blank?
      variation = ab_test('acquisition_popup_test', 'facebook', 'email')
      if variation == 'facebook'
        render json: {html: render_to_string(partial: 'show1.html.erb'), name: variation, width: "493",height: "764", color: "#fff" }
      else
        render json: {html: render_to_string(partial: 'show2.html.erb'), name: variation, width: "493",height: "764", color: "#fff" }
      end
    else
      render text: "",status: 401
    end
  end

  private
  def set
    cookies[:sm] = {
       :value => "0",
       :expires => 1.day.from_now
     }
  end

  def increment
    number = cookies[:sm].to_i
    cookies[:sm] = {
       :value => number += 1
     }
  end
end
