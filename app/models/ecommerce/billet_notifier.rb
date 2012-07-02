# encoding: utf-8
class BilletNotifier
  def self.send_reminder
    Billet.where( last_day_billets ).map do |billet|
      billet.update_attribute(:reminder_sent, true)

      BilletMailer.send_reminder_mail(billet)
    end
  end

  def self.last_day_billets(date = Date.today)
    start_time = (date-1.day).to_time
    start_time = start_time - 2.days if date.monday?
    end_time = (date-1.day).end_of_day
    { :created_at => start_time..end_time, :reminder_sent => false }
  end
end
