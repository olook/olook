module SAC
  class FraudAnalysisNotification < Notification
    
    include Notifiable

    attr_reader :type, :subscribers
    
  	def initialize
      super
      @triggers = CONFIG['fraud_analysis']['triggers']
      @subscribers = CONFIG['fraud_analysis']['subscribers']
      @type = :fraud_analysis
  	end


  end
end 