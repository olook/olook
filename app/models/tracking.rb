# -*- encoding : utf-8 -*-
class Tracking < ActiveRecord::Base
  belongs_to :user

  scope :google, where('gclid IS NOT NULL')
  scope :google_campaigns, google.group(:placement)
  scope :campaigns, where('utm_content IS NOT NULL').group(:utm_source).group(:utm_campaign).group(:utm_medium).group(:utm_content)

  def total_revenue(total = :total)
    related_orders_with_complete_payment.inject(0) do |sum, campaign|
      sum += campaign.user.total_revenue(total)
    end
  end

  def total_revenue_for_google(total = :total)
    self.class.google
        .where(:placement => self.placement)
        .joins("INNER JOIN orders on orders.user_id = trackings.user_id")
        .joins("INNER JOIN payments on orders.id = payments.order_id")
        .inject(0) do |sum, campaign|
      sum += campaign.user.total_revenue(total)
    end
  end

  def total_orders_for_google
    self.class.google
        .where(:placement => self.placement)
        .joins("INNER JOIN orders on orders.user_id = trackings.user_id")
        .joins("INNER JOIN payments on orders.id = payments.order_id")
        .where("payments.state IN ('authorized','completed')").count
  end

  def related_orders_with_complete_payment
    self.class.where(:utm_source => self.utm_source, :utm_campaign => self.utm_campaign,
                     :utm_medium => self.utm_medium, :utm_content => self.utm_content)
        .joins("INNER JOIN orders on orders.user_id = trackings.user_id")
        .joins("INNER JOIN payments on orders.id = payments.order_id")
        .where("payments.state IN ('authorized','completed')")
  end

end