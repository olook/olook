# encoding: utf-8
class Header < ActiveRecord::Base
  attr_accessible :page_title, :type, :url, :enabled, :organic_url, :product_list, :custom_url, :url_type, :new_url, :old_url, :page_description
  attr_accessor :new_url, :old_url

  validates :type, :presence => true, :exclusion => ["Header"]
  validates :url, presence: true, uniqueness: true, format: { with: /\A\//, message: 'precisa começar com /' }
  validates :organic_url, format: { with: /\A\//, message: 'precisa começar com / e ser uma url existente de catalogo, marcas ou coleção' }, if: 'self.new_url_type?'

  scope :with_type, ->(type) {where(type: type)}
  scope :newest, -> {order('created_at DESC')}

  before_validation :set_url

  HEADER_TYPES = {
    'BigBannerCatalogHeader' => BigBannerCatalogHeader,
    'SmallBannerCatalogHeader' => SmallBannerCatalogHeader,
    'NoBanner' => NoBanner,
    'TrendyCatalogHeader' => TrendyCatalogHeader,
    'MatelasseTrendyCatalogHeader' => MatelasseTrendyCatalogHeader,
    'CurvesTrendyCatalogHeader' => CurvesTrendyCatalogHeader,
    'FiorentinoTrendyCatalogHeader' => FiorentinoTrendyCatalogHeader
  }

  def self.factory params
    type = HEADER_TYPES.fetch(params[:type], TextCatalogHeader)
    type.new(params)
  end

  def self.for_url(url)
    where(enabled:true, url: url)
  end

  def organic_url=(val)
    if /https?:\/\/www.olook.com.br/ =~ val.to_s
      self[:organic_url] = val.to_s.gsub(/https?:\/\/www.olook.com.br/, '')
    else
      self[:organic_url] = val
    end
  end

  def new_url_type?
    self.url_type.to_i == 2
  end

  def old_url_type?
    self.url_type.to_i == 1
  end

  def title_text
    self[:page_title]
  end

  def text?
    false
  end

  def big_banner?
    false
  end

  def small_banner?
    false
  end

  private

  def set_url
    if self.old_url_type?
      self.url = self.old_url if self.old_url.present?
    else
      self.url = self.new_url if self.new_url.present?
    end
  end
end
