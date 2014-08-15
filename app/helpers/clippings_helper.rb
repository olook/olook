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


  def filters 
   years = (2012..DateTime.now.year).to_a
   years << ["6 Ultimos Meses", "ultimos"]
  
    years.reverse.each do |y| 
      puts y
    end
 

  end
  
 
end
