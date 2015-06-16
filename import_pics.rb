tsv = File.readlines(ARGV[0])
header = tsv.shift
ActiveRecord::Base.logger = Logger.new(STDOUT)
ps = tsv.inject({}) do |hash, _row|
  row = _row.split("\t")
  cod_pai = row[0].to_s.gsub(/-/, '')
  pic_url = row[3]
  hash[cod_pai] ||= []
  hash[cod_pai] << pic_url
  hash
end
ps.each do |cod_pai, pics|
  begin
    product = Product.find_by_model_number cod_pai
    puts("Not Found #{cod_pai}") || next if product.blank?
    next if product.pictures.size >= pics.size
    #product.pictures.destroy_all
    pics.each do |pic_url|
      r = product.pictures.create(remote_image_url: pic_url)
      puts r.inspect
    end
  rescue => e
    puts "#{e.class}: #{e.message}\n#{e.backtrace.first}"
    if e.class == Mysql2::Error
      ActiveRecord::Base.connection.reconnect!
      retry
    end
  end
end

