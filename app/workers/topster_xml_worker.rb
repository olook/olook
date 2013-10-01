class TopsterXmlWorker
  @queue = :topster_xml

  def self.perform
    xmls = TopsterXml.create_xmls
    TopsterXml.upload(xmls)
    # TopsterXml.send_to_amazon(xmls[:topster], 'topster_data.xml')
    # TopsterXml.send_to_amazon(xmls[:nextperformance], 'nextperformance_data.xml')
    # TopsterXml.send_to_amazon(xmls[:criteo], 'criteo_data.xml')
  end

end
