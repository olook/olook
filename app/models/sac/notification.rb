module SAC
	class Notification

    include Notifiable

    attr_reader :settings, :triggers, :active
    
    def initialize
      @active = true
      @settings = CONFIG['settings']
    end

	end

end