# -*- encoding : utf-8 -*-
require 'yaml'
class Survey::Link
  FILENAME = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config/survey_link.yml'))
  @@file = YAML::load(File.open(FILENAME))

  def self.generate items
    catetories = items.map{|item| item.variant.product.category unless item.is_freebie}.compact
    self.choose_link catetories
  end

  def self.choose_link categorie_ids
    sanitized_categories = self.sanitize_categories categorie_ids
    @@file[sanitized_categories]
  end

  def self.sanitize_categories categories
    categories.map{|c| c > 3 ? 4 : c}.uniq.sort.join("_")
  end
end
