# -*- encoding : utf-8 -*-
module Abacos
  class SyncOnlineInventory
    @queue = 'low'

    def self.perform
      numbers = Variant.pluck(:numbers)
      results = Abacos::ProductAPI.download_online_inventory numbers
      i_results = results.inject({}) { |h,i| h[i.last] ||= []; h[i.last].push(i.first); h }
      i_results.each do |inventory, v_numbers|
        platform_numbers = Variant.where(inventory: inventory).pluck(:number)
        update_numbers = (v_numbers - platform_numbers)
        Variant.where(number: update_numbers).update_all(inventory: inventory) if update_numbers.size > 0

        numbers_to_update = (platform_numbers - v_numbers)
        numbers_to_update.each do |number_to_update|
          new_inventory = results[number_to_update.to_s] || 0
          Variant.find_by_number(number: number_to_update).update_attributes(inventory: new_inventory)
        end
      end
    end
  end
end
