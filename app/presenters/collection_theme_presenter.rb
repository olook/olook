# -*- encoding : utf-8 -*-
class CollectionThemePresenter < BasePresenter

  def display_nav_bar
    h.render "nav", :collection_themes => collection_themes if showing_specific_category?
  end

  def render_search_form
    h.render :partial => 'moments/search_form', :locals => {:collection_theme_presenter => self}
  end

  def display_color_filters
    h.render :partial => 'moments/color_filters', :locals => {:collection_theme_presenter => self} if shoes?
  end

  def display_shoe_filters
    h.render :partial => 'moments/shoe_filters', :locals => {:collection_theme_presenter => self} if shoes?
  end

  def display_shoe_size_filters
    h.render :partial => 'moments/shoe_size_filters', :locals => {:collection_theme_presenter => self} if shoes?
  end

  def display_heel_filters
    h.render :partial => 'moments/heel_filters', :locals => {:collection_theme_presenter => self} if shoes?
  end

  def display_bag_filters
    h.render :partial => 'moments/bag_filters', :locals => {:collection_theme_presenter => self} if bags?
  end

  def display_bag_color_filters
    h.render :partial => 'moments/bag_color_filters', :locals => {:collection_theme_presenter => self} if bags?
  end

  def display_accessory_filters
    h.render :partial => 'moments/accessory_filters', :locals => {:collection_theme_presenter => self} if accessories?
  end

  private
    def showing_specific_category?
      category_id.nil?
    end

    def shoes?
      showing_specific_category? || category_id.to_i == Category::SHOE
    end

    def bags?
      showing_specific_category? || category_id.to_i == Category::BAG
    end

    def accessories?
      showing_specific_category? || category_id.to_i == Category::ACCESSORY
    end



end
