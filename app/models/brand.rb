# -*- encoding : utf-8 -*-
class Brand < ActiveRecord::Base
  attr_accessible :header_image, :header_image_alt, :name, :seo_text
  validates :name, presence: true
  mount_uploader :header_image, BannerUploader
  before_save :format_name

  CATEGORIES = {
    "olook" => %w[roupas sapatos bolsas acessórios],
    "juliana manzini" => %w[acessórios],
    "olook concept" => %w[sapatos],
    "olook essentials" => %w[sapatos]
  }

  def self.categories brand
    CATEGORIES[brand] || %w[roupas]
  end

  def title_text
    return "#{name.capitalize} - #{seo_text}" unless seo_text.blank?
    name.capitalize
  end

  private

    def format_name
      self.name = ActiveSupport::Inflector.transliterate(self.name).downcase.titleize
    end
end
