# -*- encoding : utf-8 -*-

module MarketingReports
  class Builder

    ACTIONS = [:invalid, :optout, :userbase, :userbase_orders, :userbase_revenue, :paid_online_marketing]

    attr_accessor :csv

    def initialize(type = nil)
      @csv = ""
      self.send("generate_#{type}") if ACTIONS.include? type
    end

    def upload(filename)
      FileUploader.new(@csv).copy_to_ftp(filename)
    end

    def generate_userbase
      bounced_list = generate_bounced_list
      @csv = CSV.generate do |rows|
        rows << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at
                   invite_token first_name last_name facebook_token birthday has_purchases}
        User.find_each do |u|
          unless bounced_list.include?(u.email)
            rows << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at,
                    u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, u.has_purchases?]
          end
        end
        emails_seed_list.each do |email|
          rows << [ nil, email, nil, nil, nil, nil, nil, 'seed list', nil, nil, nil, nil ]
        end
      end
    end

    def generate_userbase_orders
      selected_fields = "users.id as id, users.is_invited, users.email as email, users.first_name, users.last_name,
                         orders.id as order_id, orders.updated_at as updated_at, orders.state as order_state,
                         line_items.price as item_price, line_items.gift as gift, line_items.quantity, variants.number as variant_number,
                         products.id as product_id"

      @csv = CSV.generate do |row|
        row << %w{ id email first_name last_name invite_bonus used_bonus
                   order_id order_total order_state order_date variant_number product_id item_price gift }
        User.joins("LEFT OUTER JOIN orders on users.id = orders.user_id")
            .joins("LEFT OUTER JOIN line_items on orders.id = line_items.order_id")
            .joins("LEFT OUTER JOIN variants on line_items.variant_id = variants.id")
            .joins("LEFT OUTER JOIN products on variants.product_id = products.id")
            .select(selected_fields)
            .order("id, order_id")
            .find_each do |u|
          order_total = Order.where(:id => u.order_id).first.try(:total)
          row  << [ u.id, u.email, u.first_name, u.last_name, u.invite_bonus, u.used_invite_bonus,
                   u.order_id, order_total, u.order_state, u.updated_at , u.variant_number, u.product_id, u.item_price, u.gift ]
        end
      end
    end

    def generate_userbase_revenue
      @csv = CSV.generate do |row|
        row << %w{id email name total_bonus current_bonus used_bonus total_revenue freight}
        User.joins(:orders).joins("INNER JOIN payments on orders.id = payments.order_id").group('users.id')
            .where('payments.state IN ("authorized","completed")').each do |u|
          row <<
          [
            u.id, u.email, u.name, u.invite_bonus + u.used_invite_bonus,
            u.invite_bonus, u.used_invite_bonus, u.total_revenue(:total_with_freight),
            u.total_revenue(:freight_price)
          ]
        end
      end
    end

    def generate_paid_online_marketing
      @csv = CSV.generate do |row|
        row << %w{utm_source utm_medium utm_campaign utm_content total_registrations total_orders total_revenue_without_discount total_revenue_with_discount}
        Tracking.google_campaigns.select("placement, user_id, count(user_id) as total_registrations").each do |tracking|
          row << [
                  "google", tracking.placement, nil, nil, tracking.total_registrations, tracking.total_orders_for_google,
                  tracking.total_revenue_for_google(:line_items_total), tracking.total_revenue_for_google
                 ]
        end
        Tracking.campaigns.select('utm_source, utm_medium, utm_campaign, utm_content, user_id, count(user_id) as total_registrations').each do |tracking|
          row <<
          [
            tracking.utm_source, tracking.utm_medium, tracking.utm_campaign, tracking.utm_content, tracking.total_registrations,
            tracking.related_orders_with_complete_payment.count, tracking.total_revenue(:line_items_total), tracking.total_revenue
          ]
        end
      end
    end

    def generate_bounced_list
      responses = []
      [:invalid_emails, :spam_reports, :unsubscribes, :blocks].each do |list|
        responses += SendgridClient.new(list, :username => "olook").parsed_response
        responses += SendgridClient.new(list, :username => "olook2").parsed_response
      end
      responses.map { |item| item["email"] }
    end

    def generate_invalid
      responses = []
      ["olook", "olook2"].each do |user|
        responses += SendgridClient.new(:invalid_emails, :username => user).parsed_response
      end
      @csv = generate_email_csv(responses)
    end

    def generate_optout
      responses = []
      [:spam_reports, :unsubscribes, :blocks].each do |list|
        responses += SendgridClient.new(list, :username => "olook").parsed_response
        responses += SendgridClient.new(list, :username => "olook2").parsed_response
      end
      @csv = generate_email_csv(responses)
    end

    private

    def generate_email_csv(data)
      CSV.generate do |row|
        data.each { |item| row << [item["email"]] }
      end
    end

    def emails_seed_list
      IO.readlines(Rails.root + "lib/marketing_reports/emails_seed_list.csv").map(&:chomp)
    end

  end
end