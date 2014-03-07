# -*- encoding : utf-8 -*-
class MultiWorkersProcessSlave
  @queue = :low

  def self.perform data
    cache_key = data['cache_key']
    missing_key = data['missing_key']
    begin
      csv_content = CSV.generate(col_sep: ";") do |csv|
        map(data).each{|u| csv << [u.first_name, u.email, u.created_at.strftime("%d/%m/%Y"), u.birthday.strftime("%d/%m/%Y"), u.authentication_token, u.total.to_s]}
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

  def self.map data
    User.find_by_sql("select uuid, first_name, created_at, email, birthday, authentication_token , total from (select u.id as uuid, (
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0 and c.activates_at <= date(now()) and c.expires_at >= date(now())),0)  -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1 and c.activates_at <= date(now()) and c.expires_at >= date(now())), 0)
  ) total from users u left join user_credits uc on u.id = uc.user_id and uc.credit_type_id = 1
      where u.id >= #{data['first']} and u.id < #{data['last']}
      group by u.id
) as tmp join users on tmp.uuid = users.id") 
  end

end
