class HighlightsChooserService

  def initialize
    
  end

  def choose
    return_hash = {}
    HighlightPosition.enumeration.each do |key,value|
      return_hash[key] = choose_banner(value[0])
    end
    return_hash
  end

  private

  def choose_banner position
    @today = Date.today
    hl = Highlight.where("start_date <= ? AND end_date >= ? AND active = true AND position = ?", @today, @today, position)
    if hl.any?
      hl.last
    else
      return Highlight.where(default: true, position: position).last
    end
  end
end
