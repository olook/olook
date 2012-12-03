# == Schema Information
#
# Table name: gift_occasions
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  gift_recipient_id     :integer
#  gift_occasion_type_id :integer
#  day                   :integer
#  month                 :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class GiftOccasion < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift_occasion_type
  belongs_to :gift_recipient

  validates_associated :user, :gift_recipient, :gift_occasion_type

  validates :day, :numericality => {:only_integer => true, :greater_than => 0, :less_than => 32}
  validates :month, :numericality => {:only_integer => true, :greater_than => 0, :less_than => 13}

  delegate :name, :to => :gift_occasion_type, :allow_nil => true, :prefix => :type

  attr_accessor :date
  validates :date, :with => :validate_day_and_month_as_date

  def validate_day_and_month_as_date
    Date.new(Date.today.year,month,day) rescue errors.add :date
  end

end
