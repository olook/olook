class ClearSaleReportWorker

  @queue = :generate_clear_sale_report

  def self.perform(start_date, end_date, admin_email)
    parsed_start_date = Date.parse start_date
    parsed_end_date = Date.parse end_date

    filepath = report_file(parsed_start_date, parsed_end_date)
    mail = AdminReportMailer.send_report(filepath, admin_email)
    mail.deliver
  end

  private

    def self.report_file(start_date, end_date)
      order_numbers = ClearsaleOrderResponse.includes(:order).where(created_at: start_date.beginning_of_day..end_date.end_of_day).order('created_at desc').inject({}) do |h, c|
        k = c.order.number
        unless h[k]
          status = if c.has_pending_status?
                     "pendente"
                   elsif c.has_an_accepted_status?
                     "autorizado"
                   elsif c.has_a_rejected_status?
                     "rejeitado"
                   else
                     c.status
                   end

          h[k] = "#{c.order.number}, #{status}, #{c.status}, #{c.created_at}, #{c.order.erp_payment.total_paid}"
        end
        h
      end

      filepath = "#{ Rails.root }/tmp/clearsale#{ start_date }_#{ end_date }.csv"

      CSV.open(filepath, "w") do |csv|
        csv << ["Numero pedido", "status", "status do pedido", "data criacao", "valor da transacao"]
        order_numbers.each {|entry| csv << entry}
      end

      filepath
    end
end
