# -*- encoding : utf-8 -*-
module CustomUrlHelper

  def big_banner_img_for custom_url
    img = image_tag(@custom_url.big_banner, alt: @custom_url.alt_big_banner, title: @custom_url.alt_big_banner)

    tag = if custom_url.link_big_banner == "."
      img
    else
      link_to img, custom_url.link_big_banner
    end

    tag.html_safe
  end

end