class SaveSesInfoWorker
  @queue = 'low'

  def self.perform
    Ses::SesInfo.new.save_ses_info
  end
end
