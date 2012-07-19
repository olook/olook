# encoding: utf-8
module SAC
  class Alert

    attr_accessor :time, :header, :order_id, :message

    def initialize(header, order_id=nil, message)
      @header, @order_id, @message = set_header(header), order_id, message
    end

    private

    def set_header(header)
      header = header + ". Recebido as " + set_time_format
    end

    def set_time_format
      @time = Time.now.strftime("%d, %B %Y as %H:%M:%S")
    end

  end
end