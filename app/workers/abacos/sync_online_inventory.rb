# -*- encoding : utf-8 -*-
module Abacos
  class SyncOnlineInventory
    @queue = 'low'

    def self.perform
      numbers = ::Variant.pluck(:number)
      results = Abacos::ProductAPI.download_online_inventory numbers
      notifications = []
      i_results = results.inject({}) { |h,i| h[i.last] ||= []; h[i.last].push(i.first); h }
      i_results.each do |inventory, v_numbers|
        platform_numbers = ::Variant.where(inventory: inventory).pluck(:number)
        update_numbers = (v_numbers - platform_numbers)
        if update_numbers.size > 0
          notifications.concat(update_numbers)
          ::Variant.where(number: update_numbers).update_all(inventory: inventory)
        end

        numbers_to_update = (platform_numbers - v_numbers)
        notifications.concat(numbers_to_update)
        numbers_to_update.each do |number_to_update|
          new_inventory = results[number_to_update.to_s] || 0
          ::Variant.find_by_number(number: number_to_update).update_attributes(inventory: new_inventory)
        end
      end

      Rails.logger.info("Abacos::SyncOnlineInventory just (#{Time.zone.now.strftime('%Y-%m-%d %H:%M')}) updated #{notifications.size} variants\n#{notifications.join("\n")}")
      ActionMailer::Base.mail(
        from: 'dev@olook.com.br',
        to: ['tech@olook.com.br', 'nelsonmhjr@gmail.com'],
        subject: "Abacos::SyncOnlineInventory updated #{notifications.size} variants #{Time.zone.now.strftime('%Y-%m-%d %H:%M')}",
        body: "<pre>Abacos::SyncOnlineInventory just (#{Time.zone.now.strftime('%Y-%m-%d %H:%M')}) updated #{notifications.size} variants\n#{notifications.join("\n")}</pre>"
      ).deliver
    end
  end
end
