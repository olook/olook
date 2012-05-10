# -*- encoding : utf-8 -*-
class MomentPresenter < BasePresenter

  def render_search_form
    h.render :partial => 'moments/search_form', :locals => {:moment_presenter => self}
  end

  def display_shoe_filters
    h.render :partial => 'moments/shoe_filters', :locals => {:moment_presenter => self}
  end

  def display_shoe_size_filters
    h.render :partial => 'moments/shoe_size_filters', :locals => {:moment_presenter => self}
  end

  def display_heel_filters
    h.render :partial => 'moments/heel_filters', :locals => {:moment_presenter => self}
  end

  def display_bag_filters
    h.render :partial => 'moments/bag_filters', :locals => {:moment_presenter => self}
  end

  def display_accessory_filters
    h.render :partial => 'moments/accessory_filters', :locals => {:moment_presenter => self}
  end
end
