tsv = File.readlines(ARGV[0])
header = tsv.shift
ActiveRecord::Base.logger = Logger.new(STDOUT)
ps = tsv.inject({}) do |hash, _row|
  row = _row.split("\t")
  cod_pai = row[0].to_s.gsub(/-/, '')
  pic_url = row[2]
  hash[cod_pai] ||= []
  hash[cod_pai] << pic_url
  hash
end
ps.each do |cod_pai, pics|
  begin
    product = Product.find_by_model_number cod_pai
    puts("Not Found #{cod_pai}") || next if product.blank?
    product.pictures.destroy_all
    pics.each_with_index do |pic_url, ind|
      i = ind + 1
      i = 7 if i > 7
      data = { remote_image_url: pic_url, display_on: i, product_id: product.id }
      Resque.enqueue(PictureImporterWorker, data)
      #PictureImporterWorker.perform data
      puts "Enqueued #{data.inspect}"
    end
  rescue => e
    puts "#{e.class}: #{e.message}\n#{e.backtrace.first}"
    if e.class == Mysql2::Error
      ActiveRecord::Base.connection.reconnect!
      retry
    end
  end
end

