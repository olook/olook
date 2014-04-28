# encoding: UTF-8
class Admin::HtmlGeneratorController < Admin::BaseController
  authorize_resource :class => false
  respond_to :html, :pdf

  def index
  end

  def create
    file = params[:file]
    pdf = generate file
    send_file(pdf, :filename => pdf.path, :type => "application/pdf")
  end

  private
    def generate csv_file
      html_content = "<html><head><meta charset='utf-8'></head><body><table border=1 cellspacing=0 cellpadding=2>"

      CSV.foreach(csv_file.path, headers: false) do |row|
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
  		# config.middleware.use PDFKit::Middleware

  		# PDFKit.new takes the HTML and any options for wkhtmltopdf
  		# run `wkhtmltopdf --extended-help` for a full list of options
  		kit = PDFKit.new(html_content, :page_size => 'A4')

  		# Get an inline PDF
  		kit.to_file("pronta_entrega_atacado.pdf")
    end

end
