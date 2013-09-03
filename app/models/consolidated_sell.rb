class ConsolidatedSell < ActiveRecord::Base
  belongs_to :product

  def self.find_consolidated_record category, subcategory, day
    consolidated = where("category = ? and subcategory = ? and day = ?", category, subcategory, day).first ||
    consolidated || create(category: category, subcategory: subcategory, day: day, amount: 0, total: 0, total_retail: 0)
  end

  def self.summarized_report_for day
    where(day: day).order(:category, :subcategory)
  end

  def self.summarize date, variant, amount
    product = variant.product

    day = date.to_date
    category = product.category
    subcategory = product.subcategory

    consolidated = find_consolidated_record category, subcategory, day
    consolidated.amount += amount
    consolidated.total += amount * product.price
    consolidated.total_retail += amount * product.retail_price
    consolidated.save!
  end

end
