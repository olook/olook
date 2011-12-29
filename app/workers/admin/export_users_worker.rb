# -*- encoding : utf-8 -*-
class Admin::ExportUsersWorker
  @queue = :admin_user_export

  def self.perform(email)
    file_name = UserReport.generate_csv
    Admin::UserExportMailer.csv_ready(email, file_name).deliver
  end
end
