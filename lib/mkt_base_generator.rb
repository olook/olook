class MktBaseGenerator
  include MultiJobsProcess

  @queue = 'low'

  def execute data
    csv_content = CSV.generate(col_sep: ";") do |csv|
      map(data).each{|u| csv << create_csv_line(u) }
    end
    upload_to_s3 data['index'], csv_content
  end

  def map data
    User.find_by_sql("select uuid,
    first_name,
    DATE_FORMAT(created_at,'%Y-%m-%d') as criado_em,
    email,
    DATE_FORMAT(birthday,'%Y-%m-%d') as birthday,
    authentication_token,
    tem_pedido,
    ticket_medio,
    qtde_pedido,
    DATE_FORMAT(ultimo_pedido, '%Y-%m-%d') as ultimo_pedido,
    IF(half_user = 'TRUE', 'Half', 'Full') as tipo,
    profile,
    total
    from (
      select u.id as uuid,
      (IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0 and c.activates_at <= date(now()) and c.expires_at >= date(now())),0) -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1 and c.activates_at <= date(now()) and c.expires_at >= date(now())), 0)
  ) total, ( select IF(count(o.id) > 0, 'SIM', 'NAO' )) tem_pedido, count(o.id) qtde_pedido,  IFNULL((sum(o.gross_amount) / count(o.id)), 0) ticket_medio, (select MAX(o.created_at)) ultimo_pedido from users u left join user_credits uc on u.id = uc.user_id and uc.credit_type_id = 1 left join orders o on u.id = o.user_id and o.state in ('authorized', 'delivered', 'picking', 'delivering')
      where u.id >= #{data['first']} and u.id < #{data['last']} AND u.reseller = false
      group by u.id
  ) as tmp join users on tmp.uuid = users.id")
  end

  def split_data(max)
    indexes = prepare_indexes(max)
    (0...max).map do |i|
      first = i * indexes[:num_of_records]
      last = indexes[:num_of_records] * (i+1) - 1
      last += indexes[:left] if i == (max - 1)
      {first: first, last: last}
    end
  end

  def join
    begin
      csv = []
      CampaignEmail.uncoverted_users.find_each do |c|
        csv << [ nil, c.email, c.created_at.strftime("%d-%m-%Y"), nil, nil, nil, nil, nil, nil, nil, nil, nil].join(";")
      end

      open("tmp/base_atualizada.csv", 'wb') do |file|
        file << csv_header
        merge_csv_files_to file
        # Add newsletter base
        file << csv.join("\n")
      end



      # upload to S3
      # MarketingReports::S3Uploader.new('allin').copy_file('base_atualizada.csv')

      # save it on disk to be sent to CI machine through BitSync (Ask Nelson)
      MarketingReports::FileUploader.copy_file('base_atualizada.csv')
    rescue => e
      puts e
    end
  end

  private
    # Move the updload/download logic to another place
    def connection
      Fog::Storage.new provider: 'AWS'
    end

    def bucket
      connection.directories.get(Rails.env.production? ? "olook-ftp" : "olook-ftp-dev")
    end

    def get_uploaded_files
      bucket.files.select{|file| file.key.match( /base_geral\/fragment/) }.map{|file| file.key}
    end

    def upload_to_s3 index, csv_content
      sufix = "%02d" % index
      filename = "fragment-#{sufix}.csv"
      path = "tmp/#{filename}"
      File.open(path, "w", encoding: "ISO-8859-1") { |io| io << csv_content }
      MarketingReports::S3Uploader.new('base_geral').copy_file(filename)
    end

    def csv_header
      ['first_name', 'email address', 'criado_em', 'aniversario', 'auth_token' , 'total', 'tem_pedido', 'ticket_medio','quantidade_pedidos','ultimo_pedido','tipo', 'perfil'].join(';') + "\n"
    end
    def create_csv_line u
      [u[ 'first_name' ],
       u[ 'email' ],
       u[ 'criado_em' ],
       u[ 'birthday' ],
       u[ 'authentication_token' ],
       u[ 'total' ].to_s,
       u[ 'tem_pedido' ],
       u[ 'ticket_medio' ],
       u[ 'qtde_pedido' ],
       u[ 'ultimo_pedido' ],
       u[ 'tipo' ],
       u[ 'profile' ]]
    end

    def merge_csv_files_to file
      get_uploaded_files.each do |path|
        bucket.files.get(path) do |chunk, remaining, total|
          file.write chunk
        end
      end
    end

    def prepare_indexes(max)
      total = User.count
      num_of_records = total / max
      left = total % max + 1
      {num_of_records: num_of_records, left: left }
    end
end
