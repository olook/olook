class MktBaseGenerator
  @queue = :low

  CACHE_KEY = 'MktBaseGenerator'
  MISSING_KEY = 'MktBaseGenerator:missing'
  MAX = 10

  def self.perform data
    puts "iniciando"
    cache_key = CACHE_KEY
    missing_key = MISSING_KEY
    begin
      csv_content = CSV.generate(col_sep: ";") do |csv|
        map(data).each{|u| csv << [u.first_name, u.email, u.criado_em, u.birthday,u.authentication_token,u.total.to_s,u.tem_pedido,u.ticket_medio,u.qtde_pedido ,u.ultimo_pedido,u.tipo, u.profile]}
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
      puts "fim"
    end
  end

  def self.map data

    User.find_by_sql("select uuid, first_name, DATE_FORMAT(created_at,'%d/%m/%Y') as criado_em, email, DATE_FORMAT(birthday,'%d/%m/%Y') as birthday, authentication_token, tem_pedido, ticket_medio, qtde_pedido,
    DATE_FORMAT(ultimo_pedido, '%d/%m/%Y') as ultimo_pedido, IF(half_user = 'TRUE', 'Half', 'Full') as tipo, profile , total from (select u.id as uuid, (
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0 and c.activates_at <= date(now()) and c.expires_at >= date(now())),0) -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1 and c.activates_at <= date(now()) and c.expires_at >= date(now())), 0)
  ) total, ( select IF(count(o.id) > 0, 'SIM', 'NAO' )) tem_pedido, count(o.id) qtde_pedido,  IFNULL((sum(o.gross_amount) / count(o.id)), 0) ticket_medio, (select MAX(o.created_at)) ultimo_pedido from users u left join user_credits uc on u.id = uc.user_id and uc.credit_type_id = 1 left join orders o on u.id = o.user_id and o.state in ('authorized', 'delivery', 'picking', 'delivering')
      where u.id >= #{data['first']} and u.id < #{data['last']} AND u.reseller = false
      group by u.id
  ) as tmp join users on tmp.uuid = users.id")
  end



  def split
    total = User.count
    num_of_records = total / MAX
    left = total % MAX + 1

    datas = (0...MAX).map do |i|
      first = i * num_of_records
      last = num_of_records * (i+1) - 1
      last += left if i == (MAX - 1)
      {first: first, last: last}
    end

    datas.each_with_index do |data, index|
      data.merge!({index: index})
      Resque.enqueue(self.class, data)
    end

  end

  def join
    puts "executando o join"
    # return

    connection = Fog::Storage.new provider: 'AWS'
    dir = connection.directories.get(Rails.env.production? ? "olook-ftp" : "olook-ftp-dev")
    files = dir.files.select{|file| file.key.match( /base_geral\/fragment/) }.map{|file| file.key}

    begin
      open("tmp/base_atualizada.csv", 'wb') do |f|
        # header
        f << ['first_name', 'email address', 'criado_em', 'aniversario', 'auth_token' , 'total', 'tem_pedido', 'ticket_medio','quantidade_pedidos','ultimo_pedido','tipo', 'perfil'].join(';')
        f << "\n"
        files.each do |path|
          puts "baixando #{path}"
          dir.files.get(path) do |chunk, remaining, total|
            f.write chunk
          end
          puts "arquivo concluido."
        end
      end

      # upload
      MarketingReports::S3Uploader.new('allin').copy_file('base_atualizada.csv')

    rescue => e
      puts e
    end

    puts "Tudo concluido"

    #send an email
    DevAlertMailer.notify({to: 'rafael.manoel@olook.com.br', subject: 'geração da base concluída'}).deliver!      
    finish
  end

  def already_started?
    h = REDIS.exists(CACHE_KEY)    
    puts "running? #{h}"
    h
  end

  def has_finished?

    r = REDIS.get(MISSING_KEY).to_i
    puts "terminou ? #{r}"
    r == 0
  end

  def sleep
    Resque.enqueue(MultiWorkersProcessMaster, self.class.to_s)
  end

  def finish
    REDIS.del(CACHE_KEY)
    REDIS.del(MISSING_KEY)
  end

  def start
    REDIS.set(CACHE_KEY, Time.zone.now)
    REDIS.set(MISSING_KEY, MAX)
  end

end
