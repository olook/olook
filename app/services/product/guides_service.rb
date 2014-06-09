class Product::GuidesService
  attr_accessor :table_lines
  OLD_DETAILS = /<p/

  def initialize(details)
    @details = details
    @return_hash = {}
  end

  def process
    return @details if old_style?
    model_size, @table_lines =  @details.split('#').first, @details.split('#').last.split(";")
    {header: header_table_info, content: line_table_info, model_size: model_size}
  end

  def old_style?
    !!(@details =~ OLD_DETAILS)
  end

  private
  def header_table_info
    @return_header = @table_lines.last.split('=>').last.split(',').map{|a| a.split(':').first}
    @return_header
  end

  def line_table_info
    @table_lines.map{|a| @return_hash[a.split('=>').first] = a.split('=>').last.split(',').map{|b| b.split(':').last}}
    @return_hash
  end

end
