# -*- encoding : utf-8 -*-
module BannersHelper
  def top_banner(catalog, category_name=nil)
    category_id = Category.with_name category_name if category_name
    action_event = category_id.blank? ? "TopBannerFromShowroom" : "TopBannerFrom#{Category.key_for(category_id).to_s.camelize}"
    link_to('Roupas', "/catalogo/#{catalog}?utf8=%E2%9C%93&por=maior-desconto&cmp=liquida_#{catalog}", class: Category.for_class_name(catalog), onclick: track_event('Catalog', action_event, catalog))
  end

  #
  # => ATTENTION
  # IF YOU NEED TO CHANGE ANY LINK DON'T (DONT!!!!!!!) FORGET ABOUT UPDATING THE G.A. TRACKING!!!!!
  #
  def banner_for(category_name, options={})
    if category_name.instance_of?(Fixnum)
      category_id = category_name
    else
      category_id = Category.with_name category_name
    end
    if options[:position] == :sidetop
      path = '/colecoes/olook?utf8=%E2%9C%93&slug=olook&category_id=4&sort_filter=1&price=0-600&shoe_sizes[]='
      link_to(image_tag('moments/banner_marca_olook.jpg'), path, onclick: track_event('Catalog', "SideBanner1From#{Category.key_for(category_id).to_s.camelize}", path))
    elsif options[:position] == :sidebotton
      path = '/roupa'
      link_to(image_tag('catalog/160x600_B.jpg'), path, onclick: track_event('Catalog', "SideBanner2From#{Category.key_for(category_id).to_s.camelize}", path))
    elsif options[:position] == :botton
      link_to(image_tag('catalog/banner_quiz.jpg'), new_survey_path , onclick: track_event('Catalog', "BottomBannerFrom#{Category.key_for(category_id).to_s.camelize}", wysquiz_path))
    else
      ""
    end
  end
end
