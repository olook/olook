module SAC
  class BilletNotification < Notification
    
    attr_reader :type, :subscribers

  	def initialize
    	super
      @triggers = CONFIG['billet']['triggers']
      @subscribers = CONFIG['billet']['subscribers']
      @type = :billet
  	end

  end
end 