class HighlightsChooserService

  def choose position
    @today = Date.today
    hl = Highlight.where("start_date >= ? AND ? <= end_date AND active = true AND position = position", @today, @today)

    if hl.any?
      hl.last
    else
      return Highlight.find_all_by_default(true).last
    end
  end
end
