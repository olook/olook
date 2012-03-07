# -*- encoding : utf-8 -*-
namespace :olook do
  task :generate_billets_for_old_orders => :environment  do
    billet_table = Billet.arel_table
    pending_billets = Billet.where(billet_table[:state].eq("started").or(billet_table[:state].eq("billet_printed")))
    billet_generator = BilletGenerator.new(pending_billets)
    puts "#{billet_generator.generate} boleto(s) gerado(s) com sucesso"
  end

  task :generate_cart_links => :environment  do
    orders = %w(27934
    28025
    28055
    28005
    28088
    28081
    28113
    28100
    28130
    28085
    28226
    28285
    28339
    28360
    28467
    28499
    28494
    28555
    28567
    28570
    28583
    28593
    28626
    28729
    28716
    28765
    28752
    28837
    28858
    28836
    28860
    28864
    28936
    28977
    29040
    29098
    28658
    29171
    29203
    29140
    29271
    27982
    29301
    29300
    29314
    29311
    29293
    29343
    29339
    29386
    29396
    29408
    29405
    29481
    29465
    29498
    29501
    29564
    29640
    29680
    29722
    29758
    29753
    29780
    29785
    29809
    29842
    29979
    29996
    30075
    30079
    30176
    30326
    30373
    30415
    30451
    30577
    30717
    30732
    30728
    30948
    30956
    30963
    31034
    31088
    28502
    31187
    28422
    31214
    31254
    31257
    31374
    31435
    31434
    31454
    31539
    31583
    31651
    31659
    31763
    31821
    31838
    31848
    32002
    32060)

    orders.each do |order_id|
      order = Order.find(order_id)
      order.payment.destroy if order.payment
      order.update_attributes!(:state => "in_the_cart")
      order.generate_identification_code
      order.user.reset_authentication_token!
      order.update_attributes!(:in_cart_notified => true)
      coupon = Coupon.lock("LOCK IN SHARE MODE").find_by_id(order.used_coupon.try(:coupon_id))
      if coupon
        coupon.increment!(:remaining_amount, 1) unless coupon.unlimited?
      end
      auth_token = order.user.authentication_token
      host = Rails.env.development? ? "http://localhost:3000" : "http://www.olook.com.br"
      link = "#{http}/sacola?auth_token=#{auth_token}&order_id=#{order_id}"
      puts link
    end
  end
end
