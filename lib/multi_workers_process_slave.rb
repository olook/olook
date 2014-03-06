# -*- encoding : utf-8 -*-
class MultiWorkersProcessSlave
  @queue = :low

  def self.perform data, cache_key, missing_key
    begin
      csv_content = CSV.generate(col_sep: ";") do |csv|
        csv << ['first_name', 'Email Address', 'created_at' ]
        User.where("id < ? and id >= ?", data['last'], data['first']).each{|u| csv << [u.first_name, u.email, u.created_at]}
      end

      sufix = "%02d" % data['index']

      filename = "fragment-#{sufix}.csv"
      path = "tmp/#{filename}"
      File.open(path, "w", encoding: "ISO-8859-1") { |io| io << csv_content }
      MarketingReports::S3Uploader.new('base_geral').copy_file(filename)
    rescue => e
      puts e
    ensure
      REDIS.decr(missing_key) if REDIS.get(missing_key).to_i > 0
    end
  end

end