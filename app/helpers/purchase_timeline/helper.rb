module PurchaseTimeline
  module Helper
    
    ::BusinessTime::Config.beginning_of_workday = "8:00 am"
    ::BusinessTime::Config.end_of_workday = "6:00 pm"

    def to_timeline_date_format(order_date)
     order_date.to_date.to_s.gsub!("-",",")
    end

    def calculate_delivered_date(payment_date, delivery_estimation)
      delivery_estimation.business_days.after(payment_date).strftime('%A, %e %B %Y')
    end

    def timeline_delivered_date(payment_date, delivery_estimation)
      delivery_estimation.business_days.after(payment_date).to_date.to_s.gsub!("-",",")
    end

    def timeline_payment_expiration_date(order)
    	order.payment.payment_expiration_date.to_date.to_s.gsub!("-",",")
   	end
    
    def format_time(date)
      date.to_datetime.strftime("%H:%M:%S")
    end

    def shipping_service_art(order)
      case order.freight.shipping_service.erp_code
        when "TEX"
          "total-express.jpg"
        when "PAC"
          "correios.png"
      end
    end

  end
end