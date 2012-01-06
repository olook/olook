# -*- encoding : utf-8 -*-
class Collection < ActiveRecord::Base
  has_many :products
  
  validates :start_date, :presence => true
  validates :end_date, :presence => true
	validate :any_active_collections?
  
  def self.for_date(date)
    Collection.where( '(:date >= start_date) AND (:date <= end_date)',
                      :date => date).first
  end
  
  def self.current
    self.for_date(Date.today)
  end

	def self.active
		Collection.where(:is_active => true).first
	end

	def any_active_collections?
		collections = Collection.where(:is_active => true).all
		if self.is_active
			if collections.any? && !is_current_active?(collections)
				errors.add(:is_active, ": only one collection can be active at the same time. Deactivate an existing one before you proceed")
			end
		end
	end

	private
	def is_current_active?(collections)
		collections.collect! {|col| col.id}
		if collections.include?(self.id) 
			true
		end
	end



end
