class Clipping < ActiveRecord::Base
  attr_accessible :clipping_text, :link, :logo, :published_at, :source, :title, :pdf_file, :alt
  mount_uploader :logo, ImageUploader
  mount_uploader :pdf_file, FileUploader

  validates :clipping_text, :logo, :published_at, :source, :title, presence: true
  validates_with ClippingValidator

  scope :latest, order('published_at desc')

  def self.by_year(year)
    dt = DateTime.new(year.to_i)
    boy = dt.beginning_of_year
    eoy = dt.end_of_year
    where("published_at >= ? and published_at <= ?", boy, eoy)
  end

  def self.by_month_period month_period	
  	now = DateTime.now
  	initial = now - month_period.months
  	where("published_at >= ? and published_at <= ?", initial, now)
  end
end
