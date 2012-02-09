# -*- encoding : utf-8 -*-
class UserNotifier
  
  def self.get_orders ( status, how_long, range, validators )

  	time = Time.now.beginning_of_day
  	from = time - days_to_s( how_long + range )
    to = time - days_to_s( how_long )

    validators << "state = '#{status}'"
    validators << "updated_at >= '#{from}'"
    validators << "updated_at <= '#{to}'"


    Order.where( validators.join(" AND ") )
    
  end

  private

	def self.days_to_s ( days )
		seconds = days * 24 * 60 * 60
	end

end