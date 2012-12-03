# == Schema Information
#
# Table name: synchronization_events
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# -*- encoding: utf-8 -*-
class SynchronizationEvent < ActiveRecord::Base
  validates_presence_of :name
  validates :name, :inclusion => { :in => %w(products inventory),
    :message => "Synchronization event was not characterized as 'products' or 'inventory' or has an erroneous name." }
  validate :check_if_its_locked

  after_create :enqueue

  LOCK_TIME = 1.minutes

  private

  def check_if_its_locked
    if locked?
      errors.add(:name, 'You need to wait at least 1 minutes to create a new event.')
    end
  end

  def enqueue
    Resque.enqueue(Abacos::IntegrateProducts) if self.name == 'products'
  end

  def locked?
    unless SynchronizationEvent.last.nil?
      (SynchronizationEvent.last.created_at + LOCK_TIME > Time.now) ? true : false
    end
  end
end

