module PurchaseTimeline
  module Helper

    def timeline_date_format(order_date)
     order_date.to_date.to_s.gsub!("-",",")
    end

    def headline_time_format(date)
      date.to_datetime.strftime("%H:%M:%S")
    end

    def shipping_service_art(order)
      shipping_service = order.freight.shipping_service.erp_code.downcase
      image_tag "/assets/purchase_timeline/#{shipping_service}.png", :alt => shipping_service
    end

    def headline_delivered_date_format(payment_date, delivery_estimation)
      calculate_delivered_date(payment_date, delivery_estimation).strftime('%A, %e %B %Y')
    end

    def timeline_delivered_date_format(payment_date, delivery_estimation)
      calculate_delivered_date(payment_date, delivery_estimation).to_s.gsub!("-",",")
    end
    
    def calculate_delivered_date(payment_date, delivery_estimation)
      delivery_estimation.business_days.after(payment_date).to_date
    end

  end
end