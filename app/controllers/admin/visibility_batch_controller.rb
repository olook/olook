# encoding: UTF-8
class Admin::VisibilityBatchController < Admin::BaseController
  respond_to :html
  def new
  end

  def create
    message = nil
    arr = nil
    i = 1
    begin
      arr = {Product::PRODUCT_VISIBILITY[:site] => [],Product::PRODUCT_VISIBILITY[:olooklet] => [],Product::PRODUCT_VISIBILITY[:all] => [] }

      CSV.foreach(params[:file].path, headers: false) do |row|
        arr[row.last.to_i] << row.first.to_i
        i+=1
      end  
    rescue
      arr = nil
      message = "Opção de visibilidade inexistente na linha #{i}."
    end  

    updated_products = 0
    if arr
      arr.each do |k,v|
        updated_products += Product.where(id: v).update_all(visibility: k)
      end
    end
    message ||= "Visibilidade de #{updated_products} produtos alterada com sucesso!"
    redirect_to admin_new_visibility_batch_path, notice: message
  end

  def export
    out = CSV.generate do |csv|
      Product.all.each do |product|
        csv << [product.id, product.visibility]
      end
    end

    send_data out
  end

end
