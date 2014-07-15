# -*- encoding : utf-8 -*-
class IndexProductsWorker
  @queue = 'low'
  
  def self.perform
    d0 = Time.now.to_i
    indexer = ProductIndexer.new(Product.pluck(:id).sort { |a,b| b<=>a }, ProductProductDocumentAdapter.new)
    indexer.index
    d1 = Time.now.to_i

    puts "Total time = #{d1-d0}"

    csv_content = CSV.generate(col_sep: ';') do |csv|
      csv << ['id', 'category', 'age', 'inventory', 'brand', 'exp']
      indexer.adapter.log.each {|log_line| csv << log_line}  
    end     

    mail = DevAlertMailer.notify_about_products_index(d1-d0, csv_content)
    mail.deliver
  end

end
