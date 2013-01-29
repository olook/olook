module Admin::DashboardHelper

  def report_days_link(total,number_day, options = {})
    unless options[:state]
      options[:state] = ["authorized","picking","delivering","delivered"]
    end
    links_params = {number: number_day, state: options.fetch(:state)}
    link_to(total, admin_report_detail_path(links_params))
  end

  def report_deliver_link(number_day, options = {})
    unless options[:state]
      options[:state] = ["authorized","delivering","delivered"]
    end
    links_params = {number: number_day, state: options.fetch(:state)}

    case number_day
    when 0
      link_to(Order.with_expected_delivery_on(3.business_days.before(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    when 1
      link_to(Order.with_expected_delivery_on(2.business_days.before(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    when 2
      link_to(Order.with_expected_delivery_on(1.business_days.before(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    when 3
      link_to(Order.with_expected_delivery_on(0.business_days.after(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    when 4
      link_to(Order.with_expected_delivery_on(1.business_days.after(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    when 5
      link_to(Order.with_expected_delivery_on(2.business_days.after(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    else 6
      link_to(Order.with_expected_delivery_on(3.business_days.after(Time.now)).with_state(options[:state]).size, admin_report_detail_path(links_params))
    end
  end
end
