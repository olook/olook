# -*- encoding : utf-8 -*-
class Admin::ExportUsersWorker
  @queue = :admin_user_export

  def self.perform(email)
    UserReport.generate_csv
    Admin::UserExportMailer.csv_ready(email).deliver
  end
end
