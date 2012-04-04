module Report
  class ReportAynchronousGenerator
    # Usar diferentes estratégias para enviar para S3 ou FTP
  end 

  class ReportFactory
    # Passa como parametro a estratégia de geração e o report que deve ser gerado

    attr_accessor :csv

    def initialize(type = nil)
      @csv = ""
      self.send("generate_#{type}") if ACTIONS.include? type
    end

    def create_csv(header, content)
      @csv = CSV.generate do |rows|
        rows << header
        rows << content
      end
    end


        def copy_to_ftp(filename = "untitled.txt", encoding = "ISO-8859-1")
      ftp = Net::FTP.new(FTP_SERVER[:host], FTP_SERVER[:username], FTP_SERVER[:password])
      ftp.passive = true
      Tempfile.open(TEMP_PATH, 'w', :encoding => encoding) do |file|
        file.write @file_content
        ftp.puttextfile(file.path,filename)
      end
      ftp.close
    end

  end

  class S3Storage < ReportStorage

  end

  class FTPStorage < ReportStorage

  end

end


