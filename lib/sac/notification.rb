module SAC
	class Notification

    CONFIG = YAML.load_file("#{Rails.root.to_s}/config/sac_alert.yml")
    SETTINGS = CONFIG['settings']

    attr_reader :settings, :triggers, :subscribers, :active, :order, :type, :subject
    
    def initialize(type, subject, order)
      @settings, @subject, @active, @type, @order = SETTINGS, subject, true, type, order
      @triggers, @subscribers = load_triggers, load_subscribers
    end


    def initialize_triggers
      triggers.each do |trigger, state|
        @active = self.send("validate_#{trigger}") if state
        return unless @active == true
      end
    end

    def active?
      active
    end
    
    def validate_business_days
      Date.today.saturday? || Date.today.sunday? ? false : true
    end

    def validate_business_hours
      (Time.now > Time.parse(SETTINGS['beginning_working_hour']) && 
      Time.now < Time.parse(SETTINGS['end_working_hour'])) ? true : false
    end

    def validate_purchase_amount
      order.total_with_freight.to_f >= SETTINGS['purchase_amount_threshold'] ? true : false
    end

    # TODO: When ready, may be more interesting to use 
    # total and total without discount methods from order instead of calculating here
    def validate_discount
      total_line_items = order.line_items.collect {|p| p.price}.inject(:+)
      total_paid  = order.total
      (total_paid.to_f/total_line_items.to_f)*100 >= SETTINGS['total_discount_threshold_percent'] ? true : false
    end

    private

    def load_triggers
      CONFIG[type.to_s]['triggers']
    end

    def load_subscribers
      CONFIG[type.to_s]['subscribers']
    end

	end

end