# -*- encoding : utf-8 -*-
class MomentPresenter < BasePresenter

  def display_nav_bar
      h.render "nav", :moments => moments if showing_specific_category?
  end

  def render_search_form
    h.render :partial => 'moments/search_form', :locals => {:moment_presenter => self}
  end

  def display_color_filters
    h.render :partial => 'moments/color_filters', :locals => {:moment_presenter => self} if shoes?
  end

  def display_shoe_filters
    h.render :partial => 'moments/shoe_filters', :locals => {:moment_presenter => self} if shoes?
  end

  def display_shoe_size_filters
    h.render :partial => 'moments/shoe_size_filters', :locals => {:moment_presenter => self} if shoes?
  end

  def display_heel_filters
    h.render :partial => 'moments/heel_filters', :locals => {:moment_presenter => self} if shoes?
  end

  def display_bag_filters
    h.render :partial => 'moments/bag_filters', :locals => {:moment_presenter => self} if bags?
  end

  def display_bag_color_filters
    h.render :partial => 'moments/bag_color_filters', :locals => {:moment_presenter => self} if bags?
  end

  def display_accessory_filters
    h.render :partial => 'moments/accessory_filters', :locals => {:moment_presenter => self} if accessories?
  end
  
  def display_cloth_filters
    h.render :partial => 'moments/cloth_filters', :locals => {:moment_presenter => self} if clothes?
  end  
  
  def display_cloth_size_filters
    h.render :partial => 'moments/cloth_size_filters', :locals => {:moment_presenter => self} if clothes?
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

    def clothes?
      showing_specific_category? || category_id.to_i == Category::CLOTH
    end



end
