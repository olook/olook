class MktXmlBuilderWorker
  @queue = 'low'

  def self.perform
    xmls = MktXmlBuilder.create_xmls
    MktXmlBuilder.upload(xmls)
  end

end
