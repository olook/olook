class ExpireCartsWorker
  @queue = 'low'

  DEFAULT_UPDATED_AT_LIMIT = 30

  def self.perform(updated_at_limit=DEFAULT_UPDATED_AT_LIMIT)
    updated_at_limit = updated_at_limit.days.ago
    self.new.perform(updated_at_limit)
  end

  def perform(updated_at_limit)
    conditions = CartItem.arel_table[:id].eq(nil).and(Cart.arel_table[:updated_at].lt(updated_at_limit.beginning_of_day))
    sql = Cart.joins("LEFT JOIN `#{CartItem.table_name}` ON `#{Cart.table_name}`.`id` = `#{CartItem.table_name}`.`cart_id`").
      where(conditions)
    qty = sql.delete_all
    Rails.logger.info("DELETED #{qty} registers on #{Cart.table_name}")
  end
end
