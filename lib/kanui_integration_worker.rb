class KanuiIntegrationWorker
  @queue = 'low'

  def self.perform
    kanui_integration = KanuiIntegration.new

    if kanui_integration.enabled?
      kanui_integration.run
    end
  end

end

