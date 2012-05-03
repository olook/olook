# -*- encoding : utf-8 -*-
class Tracking < ActiveRecord::Base
  belongs_to :user

  scope :google, where('gclid IS NOT NULL')
  scope :google_campaigns, google.group(:placement)
  scope :campaigns, where('utm_content IS NOT NULL').group(:utm_source).group(:utm_campaign).group(:utm_medium).group(:utm_content)
  scope :with_complete_payment, joins("INNER JOIN orders on orders.user_id = trackings.user_id")
                                .joins("INNER JOIN payments on orders.id = payments.order_id")
                                .where("payments.state IN ('authorized','completed')")

  def self.from_day(day)
    self.where('trackings.created_at BETWEEN :day AND :next_day',:day => day, :next_day => day + 1.day)
  end

  def total_revenue(day, total = :total)
    related_with_complete_payment(day).inject(0) { |sum, campaign| sum += campaign.user.total_revenue(total) }
  end

  def total_revenue_for_google(day, total = :total)
    related_with_complete_payment_for_google(day).inject(0) { |sum, campaign| sum += campaign.user.total_revenue(total) }
  end

  def related_with_complete_payment_for_google(day)
    self.class.from_day(day).google.with_complete_payment.where(:placement => placement)
  end

  def related_with_complete_payment(day)
    self.class.from_day(day).where(:utm_source => utm_source, :utm_campaign => utm_campaign,
                     :utm_medium => utm_medium, :utm_content =>  utm_content).with_complete_payment
  end

  def clean_placement
    placement.delete(",") if placement
  end

end