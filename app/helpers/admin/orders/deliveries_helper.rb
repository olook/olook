module Admin::Orders::DeliveriesHelper
  
  def orders_delivery_link(options = {})
    unless options[:state]
      options[:state] = ["authorized","delivering","delivered"]
    end

    case options.fetch(:day_number)
    when 0
      link_to(build_scope(3.business_days.before(Time.now), options).count, admin_report_detail_path(options))

    when 1
      link_to(build_scope(2.business_days.before(Time.now), options).count, admin_report_detail_path(options))

    when 2
      link_to(build_scope(1.business_days.before(Time.now), options).count, admin_report_detail_path(options))

    when 3
      link_to(build_scope(0.business_days.after(Time.now), options).count, admin_report_detail_path(options))

    when 4
      link_to(build_scope(1.business_days.after(Time.now), options).count, admin_report_detail_path(options))

    when 5
      link_to(build_scope(2.business_days.after(Time.now), options).count, admin_report_detail_path(options))

    else 6
      link_to(build_scope(3.business_days.after(Time.now), options).count, admin_report_detail_path(options))
      
    end
  end

  def build_scope(date, options)
    if options[:action] && options[:action].match("orders_time_report")
      default_scope = Order.with_expected_delivery_on(date).with_state(options[:state])
    else
      default_scope = Order.with_date_and_authorized(date).with_state(options[:state])
    end

    scope = if freight_state_filter? && !shipping_filter?
              default_scope.where(freight_state: options[:freight_state])

            elsif shipping_filter? && !freight_state_filter?
              default_scope.where(shipping_service_name: options[:shipping_service_name])

            elsif freight_state_filter? && shipping_filter?
              default_scope.where(shipping_service_name: options[:shipping_service_name]).
                            where(freight_state: options[:freight_state])

            else
              default_scope
            end

    scope
  end

  private

    def shipping_filter?
      params[:shipping_service_name] && !params[:shipping_service_name].empty?
    end

    def freight_state_filter?
      params[:freight_state] && !params[:freight_state].empty?
    end
end
