class XmlBuilderWorker
  @queue = :xml_builder

  def self.perform
    xmls = XmlBuilder.create_xmls
    XmlBuilder.upload(xmls)
  end

end
