# -*- encoding : utf-8 -*-
class FiltersPresenter
  include Rails.application.routes.url_helpers


  def initialize olooklet_or_selection
    @for = olooklet_or_selection
  end

  def path(value=nil)
    if @for == 'olooklet'
      olooklet_path(value).html_safe
    else
      selections_path(value).html_safe
    end
  end

  def section_name
    @for == 'olooklet' ? 'Olooklet' : 'Seleções especiais'
  end

  def show_current_section?
    @for == 'olooklet'
  end


end