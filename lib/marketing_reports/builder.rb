# -*- encoding : utf-8 -*-

module MarketingReports
  class Builder

    ACTIONS = [:invalid, :optout, :userbase, :userbase_orders, :userbase_revenue, :paid_online_marketing]

    attr_accessor :csv

    def initialize(type = nil)
      @csv = ""
      self.send("generate_#{type}") if ACTIONS.include? type
    end

    def upload(filename, encoding = "ISO-8859-1")
      FileUploader.new(@csv).copy_to_ftp(filename, encoding)
    end

    def generate_userbase
      data = []
      data << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at
                 invite_token first_name last_name facebook_token birthday has_purchases}
      User.find_each do |u|
        unless bounced_list.include?(u.email)
          data << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at,
                  u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, u.has_purchases?]
        end
      end
      emails_seed_list.each { |email| data << [ nil, email, nil, nil, nil, nil, nil, 'seed list', nil, nil, nil, nil ] }
      @csv = build_csv(data)
    end

    def generate_userbase_orders
      data = []
      selected_fields = "users.id as id, users.is_invited, users.email as email, users.first_name, users.last_name,
                         orders.id as order_id, orders.updated_at as updated_at, orders.state as order_state,
                         line_items.price as item_price, line_items.gift as gift, line_items.quantity, variants.number as variant_number,
                         products.id as product_id"
      data << %w{ id email first_name last_name invite_bonus used_bonus
                   order_id order_total order_state order_date variant_number product_id item_price gift }

      User.joins("LEFT OUTER JOIN orders on users.id = orders.user_id")
          .joins("LEFT OUTER JOIN line_items on orders.id = line_items.order_id")
          .joins("LEFT OUTER JOIN variants on line_items.variant_id = variants.id")
          .joins("LEFT OUTER JOIN products on variants.product_id = products.id")
          .select(selected_fields)
          .order("id, order_id")
          .find_each do |u|
        order_total = Order.where(:id => u.order_id).first.try(:total)
        data  << [ u.id, u.email, u.first_name, u.last_name, u.invite_bonus, u.used_invite_bonus,
                 u.order_id, order_total, u.order_state, u.updated_at , u.variant_number, u.product_id, u.item_price, u.gift ]
      end
      @csv = build_csv(data)
    end

    def generate_userbase_revenue
      data = []
      data << %w{id email name total_bonus current_bonus used_bonus total_revenue freight}

      User.joins(:orders).joins("INNER JOIN payments on orders.id = payments.order_id").group('users.id')
          .where('payments.state IN ("authorized","completed")').each do |u|
        data << [ u.id, u.email, u.name, u.invite_bonus + u.used_invite_bonus, u.invite_bonus, u.used_invite_bonus,
                  u.total_revenue(:total_with_freight), u.total_revenue(:freight_price) ]
        end
      @csv = build_csv(data)
    end

    def generate_paid_online_marketing(from = (Date.today - 1.week) , to = Date.today)
      data = []
      data << %w{date utm_source utm_medium utm_campaign utm_content total_registrations total_orders total_revenue_without_discount total_revenue_with_discount}
      (from...to).each do |day|
        Tracking.from_day(day).google_campaigns.select("placement, user_id, count(user_id) as total_registrations").each do |t|
          data << [ day.to_s, "google", t.clean_placement, nil, nil, t.total_registrations, t.related_with_complete_payment_for_google.count,
                    t.total_revenue_for_google(:line_items_total), t.total_revenue_for_google ]
        end
        Tracking.from_day(day).campaigns.select('utm_source, utm_medium, utm_campaign, utm_content, user_id, count(user_id) as total_registrations').each do |t|
          data <<
          [ day.to_s, t.utm_source, t.utm_medium, t.utm_campaign, t.utm_content, t.total_registrations,
            t.related_with_complete_payment.count, t.total_revenue(:line_items_total), t.total_revenue ]
        end
      end
      @csv = build_csv(data)
    end

    def generate_invalid
      @csv = build_email_csv sendgrid_accounts_response(:invalid_emails)
    end

    def generate_optout
      responses = [:spam_reports, :unsubscribes, :blocks].inject([]) do |sum, service|
        sum += sendgrid_accounts_response(service)
      end
      @csv = build_email_csv responses
    end

    private

    def build_csv(data)
      CSV.generate { |csv| data.each { |line| csv << line } }
    end

    def build_email_csv(data)
      CSV.generate { |row| data.each { |item| row << [item["email"]] } }
    end

    def emails(data)
      data.map { |item| item["email"] }
    end

    def bounced_list
      responses = [:invalid_emails, :spam_reports, :unsubscribes, :blocks].inject([]) do |sum, service|
        sum += sendgrid_accounts_response(service)
      end
      emails(responses)
    end

    def sendgrid_accounts_response(service)
      ["olook", "olook2"].inject([]) do |total, user|
        total += SendgridClient.new(service, :username => user).parsed_response
      end
    end

    def emails_seed_list
      IO.readlines(Rails.root + "lib/marketing_reports/emails_seed_list.csv").map(&:chomp)
    end

  end
end