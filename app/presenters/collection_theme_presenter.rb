# -*- encoding : utf-8 -*-
class CollectionThemePresenter < BasePresenter

  def display_nav_bar
    h.render "nav", :collection_themes => collection_themes if showing_specific_category?
  end

  def display_color_filters
    h.render :partial => 'shared/filters/color_filters', :locals => {:collection_theme_presenter => self, product_type: category_type}
  end

  def display_shoe_filters
    h.render :partial => 'shared/filters/shoe_filters', :locals => {:collection_theme_presenter => self} if shoes?
  end

  def display_care_shoe_filters
    h.render :partial => 'shared/filters/care_shoe_filters', :locals => {:collection_theme_presenter => self} if shoes?
  end

  def display_shoe_size_filters
    h.render :partial => 'shared/filters/shoe_size_filters', :locals => {:collection_theme_presenter => self} if shoes?
  end

  def display_news_filters
    h.render :partial => 'shared/filters/news_filters', :locals => {:collection_theme_presenter => self} #if shoes?
  end

  def display_heel_filters
    h.render :partial => 'shared/filters/heel_filters', :locals => {:collection_theme_presenter => self} if shoes?
  end

  def display_bag_filters
    h.render :partial => 'shared/filters/bag_filters', :locals => {:collection_theme_presenter => self} if bags?
  end

  def display_accessory_filters
    h.render :partial => 'shared/filters/accessory_filters', :locals => {:collection_theme_presenter => self} if accessories?
  end

  def display_brand_filters
    h.render :partial => 'shared/filters/brand_filters', :locals => {:collection_theme_presenter => self} if accessories? || clothes?
  end

  def display_cloth_filters
    h.render :partial => 'shared/filters/cloth_filters', :locals => {:collection_theme_presenter => self} if clothes?
  end

  def display_cloth_size_filters
    h.render :partial => 'shared/filters/cloth_size_filters', :locals => {:collection_theme_presenter => self} if clothes?
  end

  private

    def category_type
      case !category_id.blank?
      when category_id.to_i == Category::SHOE then
        "shoe"
      when category_id.to_i == Category::BAG then
        "bag"
      when category_id.to_i == Category::ACCESSORY then
        "accessory"
      else
        "cloth"
      end
    end

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
