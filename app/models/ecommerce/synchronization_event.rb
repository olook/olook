# -*- encoding: utf-8 -*-
class SynchronizationEvent < ActiveRecord::Base
  validates_presence_of :name
  before_save :validates_name

  LOCK_TIME = 10.minutes

  protected

  def self.locked?
    self.last.created_at + LOCK_TIME < Time.now
  end

  private

  def validates_name
    unless self.name == "products" || self.name == "inventory"
      raise "This synchronization event is not characterized as 'products' or 'inventory' or has an erroneous name." 
    end
  end
end

