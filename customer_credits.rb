ActiveRecord::Base.logger = Logger.new STDOUT

header = ["UserID", "Email", "CreditsAvailable", "FutureCredits", "QtyOrders", "LastOrder"]

CSV.open('customer_credits.csv', 'wb', encoding: 'iso-8859-1') do |csv|
  csv << header
  User.find_each(batch_size: 1000) do |user|
    row = []
    row.push(user.id)
    row.push(user.email)

    report  = CreditReportService.new(user)
    loyalty_credits = report.loyalty_credits
    invite_credits  = report.invite_credits
    redeem_credits  = report.redeem_credits
    used_credits    = report.used_credits
    refunded_credits = report.refunded_credits
    available_credits = report.available_credits
    holding_credits = report.holding_credits

    row.push(available_credits)
    row.push(holding_credits)
    row.push(user.orders.paid.count)
    row.push(user.orders.paid.order(:created_at).last.try(:created_at))

    csv << row
  end
end

`gzip -f9 customer_credits.csv`
class ReportMailer < ActionMailer::Base
  def report
    attachments['customer_credits.csv.gz'] = File.read('customer_credits.csv.gz')
    mail(from: 'tech@olook.com.br', to: 'nelsonmhjr@gmail.com', subject: "Report Customer Credits") do |format|
      format.text { render text: 'User Credits' }
      format.html { render text: '<p>User <b>Credits</b></p>'.html_safe }
    end
  end
end

ReportMailer.report.deliver
