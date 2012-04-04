class OrderReport < ReportFactory

  
    ACTIONS = [:purchase_profile_matrix]

=begin
This report generates a purchase of profiles matrix
=end

  def generate_purchase_profile_matrix
    report = {:Fashionista => [0,0,0,0,0,0,0,0], :Sexy => [0,0,0,0,0,0,0,0], :Básica => [0,0,0,0,0,0,0,0], 
    :Elegante => [0,0,0,0,0,0,0,0], :Feminina => [0,0,0,0,0,0,0,0], :Tradicional => [0,0,0,0,0,0,0,0],
    :Trendy => [0,0,0,0,0,0,0,0]}

   Order.where("state <> 'in_the_cart' AND state <> 'waiting_payment' AND state <> 'canceled'").each do |order|
    if order.user != nil
      if !order.user.points.empty?
        user_profile = Profile.find(order.user.profile_scores[0].profile_id)
          order.line_items.each do |ln|
            report[user_profile.name.to_sym][7] = report[user_profile.name.to_sym][7] + 1
            ln.variant.product.profiles.each do |profile|
              idx = 0
              report.each_key do |k|
                if profile.name.to_sym == k
                  report[user_profile.name.to_sym][idx] = report.fetch(user_profile.name.to_sym)[idx] + 1
                end
                idx = idx + 1
              end
            end
          end
        end
      end
    end
    @csv = CSV.generate do |rows|
      rows << %w{X Fashionista Sexy Básica Elegante Feminina Tradicional Trendy Total}
      report.each do |k, v|
        rows << [k.to_s, v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7]]
      end
    end
  end

end