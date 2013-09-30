class TopsterXmlWorker
  @queue = :topster_xml

  def self.perform
    xmls = TopsterXml.create_xml([:topster, :nextperformance])
    TopsterXml.send_to_amazon(xmls[:topster], 'topster_data.xml')
    TopsterXml.send_to_amazon(xmls[:nextperformance], 'nextperformance_data.xml')
  end

end
