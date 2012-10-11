# -*- encoding : utf-8 -*-
module MomentsHelper

  def msn_tags
    image_tag "http://view.atdmt.com/action/mmn_olook_colecoes#{@moment.id}", size: "1x1"
  end

end
