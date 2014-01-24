# -*- encoding : utf-8 -*-
class MarketingBaseUploaderWorker
  # No momento soh precisamos gerar e subir o csv de aniversariantes por aqui
  # e mandar pela exact target
  def self.perform
    info_ftp = 'exact_target.yml'

    csv_content = CSV.generate(col_sep: ";") do |csv|
      csv << ['first_name', 'Email Address', 'birthday', 'auth_token' ]
      User.find_each do |u|
          csv << [ u.first_name, u.email.chomp, u.birthday, u.authentication_token ]
      end
    end

    file_name = "tmp/aniversariantes.csv"
    File.open(file_name, "w", encoding: "ISO-8859-1") { |io| io << csv_content }

    ::MarketingReports::FtpUploader.new("aniversariantes.csv", info_ftp)
      .upload_to_ftp if Rails.env.production?

  end
end
