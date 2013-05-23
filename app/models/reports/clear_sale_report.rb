class ClearSaleReport

  def initialize(start_date, end_date, admin)
    @start_date = parse start_date
    @end_date = parse end_date
    @admin = admin
  end

  def schedule_generation
    Resque.enqueue(ClearSaleReport, @start_date, @end_date, @admin.email)
  end

  def self.report_file(start_date, end_date)
    _order_numbers = ClearsaleOrderResponse.includes(:order).where(created_at: start_date.beginning_of_day..end_date.end_of_day).order('created_at desc').inject({}) do |h, clear_sale_response|
      order_number = clear_sale_response.order.number
      unless h[order_number]
        status = if clear_sale_response.has_pending_status?
                   "pendente"
                 elsif clear_sale_response.has_an_accepted_status?
                   "autorizado"
                 elsif clear_sale_response.has_a_rejected_status?
                   "rejeitado"
                 else
                   c.status
                 end

        h[order_number] = "#{clear_sale_response.order.number}, #{status}, #{clear_sale_response.status}, #{clear_sale_response.created_at}, #{clear_sale_response.order.erp_payment.total_paid}"
      end
      h
    end

    filepath = "#{ Rails.root }/tmp/clearsale#{ start_date }_#{ end_date }.csv"

    CSV.open(filepath, "w") do |csv|
      csv << ["Numero pedido", "status", "status do pedido", "data criacao", "valor da transacao"]
      _order_numbers.each {|entry| csv << entry}
    end

    filepath
  end

  private

    def parse date
      date.to_a.sort.collect{|c| c[1]}.join("-")
    end
end
