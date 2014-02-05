class ConsolidatedSell < ActiveRecord::Base
  belongs_to :product

  scope :in_last_week, where('day BETWEEN ? AND ?', (Time.zone.today - 8.days), (Time.zone.today - 1.days))

  def self.find_or_create_consolidated_record product, day
    consolidated = where("category = ? and subcategory = ? and day = ?", product.category, product.subcategory, day).first
    consolidated || create_consolidated_sell_for(product, day)
  end

  def self.summarized_report_for day
    where(day: day).order(:category, :subcategory)
  end

  def self.summarize date, product, amount
    consolidated = find_or_create_consolidated_record(product, date)
    consolidated.amount += amount
    consolidated.total += amount * product.price
    consolidated.total_retail += amount * product.retail_price
    consolidated.save!
  end

  private
    def self.create_consolidated_sell_for product, day
      product.consolidated_sells.create(category: product.category, subcategory: product.subcategory, day: day, amount: 0, total: 0, total_retail: 0)
    end

end
