# -*- encoding: utf-8 -*-
class SynchronizationEvent < ActiveRecord::Base
  validates_presence_of :name
  before_save :validates_name
  after_create :enqueue

  LOCK_TIME = 10.minutes
  ALLOWED_NAMES = ["products", "inventory"]

  protected

  def self.locked?
    (self.last.created_at + LOCK_TIME > Time.now) ? true : false
  end

  private

  def enqueue
    Resque.enqueue(Abacos::IntegrateProducts) if self.name == 'products'
  end

  def validates_name
    unless ALLOWED_NAMES.include?(self.name)
      raise "This synchronization event is not characterized as 'products' or 'inventory' or has an erroneous name." 
    end
  end
end

