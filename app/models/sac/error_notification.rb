module SAC
  class ErrorNotification < Notification
    
    attr_reader :type, :subscribers

  	def initialize
      super
      @triggers = CONFIG['error']['triggers']
      @subscribers = CONFIG['error']['subscribers']
      @type = :error
  	end

  end
end 