module Admin::DashboardHelper

  def report_days_link(number_day, options = {})
    unless options[:state]
      options[:state] = ["authorized","picking","delivering","delivered"]
    end
    links_params = {number: number_day, state: options.fetch(:state)}
    link_to(Order.with_date(number_day.business_days.before(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
  end

  def report_deliver_link(number_day, options = {})
    unless options[:state]
      options[:state] = ["authorized","delivering","delivered"]
    end
    links_params = {number: number_day, state: options.fetch(:state)}
    if number_day <= 3
      link_to(Order.with_date(number_day.business_days.before(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    else
      link_to(Order.with_date(number_day.business_days.after(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    end
  end
end
