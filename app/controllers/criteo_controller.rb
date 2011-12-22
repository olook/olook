class CriteoController < ApplicationController
  def show
    instock = Proc.new { |options, record| options[:builder].tag!('instock', !record.sold_out?) }
    producturl = Proc.new { |options, record| options[:builder].tag!('producturl', product_url(record)) }
    bigimage = Proc.new { |options, record| options[:builder].tag!('bigimage', record.suggestion_picture) }
    smallimage = Proc.new { |options, record| options[:builder].tag!('smallimage', record.thumb_picture) }



    @products = Product.only_visible.all
    respond_to do |format|
      format.xml do
        render :xml => @products.to_xml(:skip_types => true, :methods => [:price],
                                        :only => [:name, :description, :id],
                                        :procs => [instock, producturl, bigimage, smallimage])
      end
    end
  end
end
