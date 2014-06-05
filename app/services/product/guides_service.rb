class Product::GuidesService
  attr_accessor :model_size, :table_lines
  OLD_DETAILS = /<p/

  def initialize(details)
    @details = details
    @return_hash = {}
  end

  def process
    @model_size,@table_lines =  @details.split('#').first, @details.split('#').last.split(";")
    binding.pry
    @table_lines.each do |t|
      a = t.split("=>")
      @return_hash[a.first] = a.last
    end
    @return_hash
  end

  def old_style?
    !!(@details =~ OLD_DETAILS)
  end

  private

end
