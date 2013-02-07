module Admin::Orders::StatusesHelper

  def orders_status_link(options = {})

    extract_options!(options)

    options[:state] = ["authorized","picking","delivering","delivered"] unless options[:state]

    total = options.fetch(:total)

    # routing isn't working properly
    # link_to(total, admin_orders_status_path(options))
    link_to(total, "statuses/show?#{options.to_params}")
  end

  def build_scope(date, options)
    options = extract_options!(options)

    default_scope = Order.with_date_and_authorized(date).with_state(options[:state])

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

    def extract_options!(options)
      options = options.to_hash
      options.symbolize_keys!.slice!(:total, :day_number, :state, :freight_state, :shipping_service_name)
      options
    end
end
