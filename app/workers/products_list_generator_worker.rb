# -*- encoding : utf-8 -*-
class ProductsListGeneratorWorker

  @queue = 'low'

  def self.perform lines, email_to

    html_content = "<html><head><meta charset='utf-8'></head><body><table border=1 cellspacing=0 cellpadding=2>"

    lines.each do |row|
      html_content+="<tr>"      
      product_id = row.first.to_i

      row.each_with_index do |column, index|
        value = if index == 1 && product_id != 0
          begin
            img_src = Product.find(product_id).main_picture.image_url(:catalog)
            "<img src='http:#{img_src}'/>"
          rescue => e
            puts product_id
            "-"
          end
        else
          column
        end

        html_content+="<td>#{value}</td>"
      end

      html_content+="</tr>"
    end

    html_content += "</body></html>"

    # TODO => This could be on an initializer
    PDFKit.configure do |config|
      config.wkhtmltopdf = `which wkhtmltopdf`.to_s.strip
      config.default_options = {
        :encoding=>"UTF-8",
        :page_size=>"A4",
        :margin_top=>"0.25in",
        :margin_right=>"1in",
        :margin_bottom=>"0.25in",
        :margin_left=>"1in",
        :disable_smart_shrinking=>false
        }
    end

    # PDFKit.new takes the HTML and any options for wkhtmltopdf
    # run `wkhtmltopdf --extended-help` for a full list of options
    kit = PDFKit.new(html_content, :page_size => 'A4')

    # Get an inline PDF
    # file = kit.to_file("pronta_entrega_atacado.pdf")
    pdf = kit.to_pdf

    uploader = MarketingReports::S3Uploader.new "olook"
    filename = "products-#{DateTime.now.to_i}.pdf"
    url = uploader.upload(filename, pdf, true)

    DevAlertMailer.notify_products_list_generated(email_to, url).deliver
  end


end