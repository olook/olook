class ExpireCartsWorker
  @queue = 'low_priority'

  DEFAULT_UPDATED_AT_LIMIT = 7.days.ago
  BKP_TABLE_NAME = 'carts_backup'

  def self.perform(updated_at_limit=DEFAULT_UPDATED_AT_LIMIT)
    self.new.perform(updated_at_limit)
  end

  def perform(updated_at_limit)

    1000.times do 

      conditions = CartItem.arel_table[:id].eq(nil).and(Cart.arel_table[:updated_at].lt(updated_at_limit.beginning_of_day))
      select = Cart.joins("LEFT JOIN `#{CartItem.table_name}` ON `#{Cart.table_name}`.`id` = `#{CartItem.table_name}`.`cart_id`").
        where(conditions).limit(100000)
      if(Cart.connection.execute("DESC #{BKP_TABLE_NAME}") rescue false)
        qty_inserts = Cart.connection.insert("REPLACE `#{BKP_TABLE_NAME}` #{select.to_sql}")
        Rails.logger.info("INSERTED #{qty_inserts} registers on #{BKP_TABLE_NAME}")
        carts_ids = select.map { |c| c.id }
        deleted_carts = 0
        deleted_carts += Cart.where(id: carts_ids.shift(100)).delete_all until carts_ids.empty?
        Rails.logger.info("DELETED #{deleted_carts} registers on #{Cart.table_name}")
      else
        Rails.logger.error("There is not a table named #{BKP_TABLE_NAME} please create_it")
      end
    end
  end
end
