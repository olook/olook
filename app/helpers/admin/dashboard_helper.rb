module Admin::DashboardHelper

  def report_days_link(number_day, options = {})
    unless options[:state]
      options[:state] = ["authorized","picking","delivering","delivered"]
    end
    links_params = {number: number_day, state: options.fetch(:state)}
    link_to(Order.with_date(Time.now - number_day.days).with_state(options[:state]).size, admin_report_detail_path(links_params))
  end

end
