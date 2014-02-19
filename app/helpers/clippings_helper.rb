# encoding: utf-8
module ClippingsHelper
  def show_link clipping
    if clipping.link.blank?

      if clipping.pdf_file_url =~ /http/
        clipping.pdf_file_url
      else
        "http:#{clipping.pdf_file_url}"
      end

    else
      clipping.link
    end
  end
end
