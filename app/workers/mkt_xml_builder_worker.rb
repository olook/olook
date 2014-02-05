class MktXmlBuilderWorker
  @queue = :mkt_xml_builder

  def self.perform
    xmls = MktXmlBuilder.create_xmls
    MktXmlBuilder.upload(xmls)
  end

end
