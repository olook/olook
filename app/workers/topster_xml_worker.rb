class TopsterXmlWorker
  @queue = :topster_xml

  def self.perform
    xmls = TopsterXml.create_xmls
    TopsterXml.upload(xmls)
  end

end
