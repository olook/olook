class HighlightsChooserService

  def initialize
    
  end

  def choose position
    @today = Date.today
    hl = Highlight.where("start_date >= ? AND ? <= end_date AND active = true AND position = ?", @today, @today, position)
    if hl.any?
      hl.last
    else
      return Highlight.where(default: true, position: position).last
    end
  end
end
