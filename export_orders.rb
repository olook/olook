ActiveRecord::Base.logger = Logger.new(STDOUT)
CSV.open 'export_orders.csv', 'wb' do |csv|
  csv << ['ORDER', '', '', '', '', '']
  csv << ["Order ID", "Shop Name", "Customer ID", "Purchase Date", "Order Value", "Invoice URL"]
  Order.includes(:payments).find_each(batch_size: 1000) do |order|
    row = []

    row << order.number
    row << "Olook"
    row << order.user_id
    row << order.created_at.strftime("%d/%m/%Y")
    row << order.amount_paid
    row << order.erp_payment.try(:url)

    csv << row
    puts row.inspect
  end
end
