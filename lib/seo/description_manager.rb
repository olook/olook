# -*- encoding : utf-8 -*-
require 'yaml'
class Seo::DescriptionManager
  FILENAME = File.expand_path(File.join(File.dirname(__FILE__), '../..', 'config/seo_description.yml'));
  DEFAULT = "Roupas femininas, sapatos, bolsas, óculos e acessórios incríveis - Olook. Seu look, seu estilo"
  @@file = YAML::load(File.open(FILENAME))
  attr_accessor :description_key

  def initialize options = {}
    @description_key = options[:description_key]
  end

  def choose
    return DEFAULT if description_key.blank? || search_description_key.blank?
    get_description_file[description_key.downcase]
  end

  private
  def search_description_key
    get_description_file.keys.select{|key| key =~ /#{description_key}/i}
  end
  def get_description_file
    @@file
  end
end
