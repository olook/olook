# == Schema Information
#
# Table name: collections
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_date :date
#  end_date   :date
#  created_at :datetime
#  updated_at :datetime
#  is_active  :boolean          default(FALSE)
#

# -*- encoding : utf-8 -*-
class Collection < ActiveRecord::Base
  has_many :products

  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validate :any_active_collections?

  def self.from_last_month
    Collection.where('id < ?', Collection.active.try(:id)).order('id desc').first
  end

  def self.for_date(date)
    Collection.where( '(:date >= start_date) AND (:date <= end_date)', :date => date).first
  end

  def self.current
    self.for_date(Date.today)
  end

  def self.active
    Collection.where(:is_active => true).first
  end

  private

  def any_active_collections?
    collections = Collection.where(:is_active => true).all
    if self.is_active
      if collections.any? && !is_current_active?(collections)
        errors.add(:is_active, ": only one collection can be active at the same time. Deactivate an existing one before you proceed")
      end
    end
  end

  def is_current_active?(collections)
    collections.collect! {|col| col.id}
    if collections.include?(self.id)
      true
    end
  end
end
