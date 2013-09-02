# encoding: utf-8
module ClippingsHelper
  def show_link clipping
    if clipping.link.blank?
      "http:#{clipping.pdf_file_url}"
    else
      clipping.link
    end
  end
end
