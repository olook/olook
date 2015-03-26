# -*- encoding : utf-8 -*-
class IndexProductsWorker
  @queue = 'low'
  
  def self.perform(ids=nil)
    d0 = Time.now.to_i
    ids ||= Product.pluck(:id).sort { |a,b| b<=>a }
    indexer = ProductIndexer.new(ids, ProductProductDocumentAdapter.new)
    indexer.index
    d1 = Time.now.to_i

    puts "Total time = #{d1-d0}"

    REDIS.select 3
    REDIS.flushdb

    mail = DevAlertMailer.notify_about_products_index(d1-d0, indexer.adapter.log.join("\n"))
    mail.deliver
  end

  def process(n=100)
    ids = YAML.load(File.read('/tmp/process_products.yml'))
    to_process = ids.select { |k,v| !v }.keys
    is = to_process.shift(n)
    IndexProductsWorker.perform is
    is.each { |i| ids[i] = true }
    File.open('/tmp/process_products.yml', 'w') { |f| f.puts YAML.dump(ids) }
  end

end
