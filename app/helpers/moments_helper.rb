# -*- encoding : utf-8 -*-
module MomentsHelper

  def msn_tags
    image_tag "http://view.atdmt.com/action/mmn_olook_colecoes#{@moment.id}", size: "1x1"
  end

  def installments(price)
    number_of_installments = 4
    installment_price = price / 4
    "#{number_of_installments} x de #{number_to_currency(installment_price)}"
  end

end
