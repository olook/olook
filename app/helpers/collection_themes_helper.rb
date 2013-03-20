# -*- encoding : utf-8 -*-
module CollectionThemesHelper
  MIN_INSTALLMENT_VALUE = 30
  MAX_INSTALLMENT_NUMBER = 6

  def msn_tags
    image_tag "http://view.atdmt.com/action/mmn_olook_colecoes#{@collection_theme.id}", size: "1x1"
  end

  def installments(price)
    installments = number_of_installments_for(price)
    installment_price = price / installments
    "#{installments} x de #{number_to_currency(installment_price)}"
  end

  def print_section_name
    {shoes_path => "sapatos", accessories_path => "acessórios", bags_path => "bolsas", clothes_path => "Roupas"}[request.fullpath]
  end

  def available_categories_options_for(catalog_search_service=nil)
    categories = Category.to_a
    if catalog_search_service.respond_to?(:filter_without_paginate)
      categories_in_query = catalog_search_service.filter_without_paginate.group(:category_id).count.keys
      categories.select! { |opt| categories_in_query.include?(opt.last) }
    end
    options_for_select(categories.unshift(["Todas", nil]))
  end

  private
    def number_of_installments_for price
      return 1 if price <= MIN_INSTALLMENT_VALUE
      return MAX_INSTALLMENT_NUMBER if price >= MIN_INSTALLMENT_VALUE * MAX_INSTALLMENT_NUMBER

      price.to_i / MIN_INSTALLMENT_VALUE
    end

end
