class TopsterXmlWorker
  @queue = :topster_xml

  def self.perform
    xml = TopsterXml.create_xml
    TopsterXml.send_to_amazon xml
  end

end
