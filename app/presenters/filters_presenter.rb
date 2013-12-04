class FiltersPresenter
  include Rails.application.routes.url_helpers

  def initialize olooklet_or_selection
    @for = olooklet_or_selection
  end

  def path(value)
    if @for == 'olooklet'
      olooklet_path(value).html_safe
    else
      selections_path(value).html_safe
    end
  end

end