# -*- encoding : utf-8 -*-
require 'net/ftp'
require 'tempfile'

module EmailMarketing
  class CsvUploader
    FTP_SERVER = {
      :host => "hftp.olook.com.br",
      :username => "allinmail",
      :password => "allinmail123abc"
    }

    FILE_PATH =  "/tmp/"

    ACTIONS = [:invalid, :optout, :userbase, :userbase_orders, :userbase_revenue]

    attr_reader :csv

    def initialize(type = nil)
      if ACTIONS.include? type
        self.send("generate_#{type}")
      else
        @csv = ""
      end
    end

    def copy_to_ftp(filename = "untitled.txt")
      ftp = Net::FTP.new(FTP_SERVER[:host], FTP_SERVER[:username], FTP_SERVER[:password])
      ftp.passive = true
      Tempfile.open(FILE_PATH, 'w', :encoding => 'ISO-8859-1') do |file|
        file.write @csv
        ftp.puttextfile(file.path,filename)
      end
      ftp.close
    end

    private

    def generate_userbase
      bounced_list = generate_bounced_list
      @csv = CSV.generate do |row|
        row << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at
                   invite_token first_name last_name facebook_token birthday }
        User.find_each do |u|
          unless bounced_list.include?(u.email)
            row << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at,
                    u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday ]
          end
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
            .each do |u|
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
          total, freight_total = 0, 0
          Order.joins("INNER JOIN payments on orders.id = payments.order_id")
               .where('payments.state IN ("authorized","completed") and orders.user_id = ?', u.id).all.each do |order|
            total += order.total_with_freight
            freight_total += order.freight_price
          end
          row << [u.id, u.email, u.name, u.invite_bonus + u.used_invite_bonus, u.invite_bonus, u.used_invite_bonus, total, freight_total]
        end
      end
    end

    def generate_bounced_list
      responses = []
      [:invalid_emails, :spam_reports, :unsubscribes, :blocks].each do |list|
        responses += SendgridClient.new(list).parsed_response
      end
      responses.map { |item| item["email"] }
    end

    def generate_email_csv(data)
      CSV.generate do |row|
        data.each { |item| row << [item["email"]] }
      end
    end

    def generate_invalid
      @csv = generate_email_csv(SendgridClient.new(:invalid_emails).parsed_response)
    end

    def generate_optout
      responses = []
      [:spam_reports, :unsubscribes, :blocks].each do |list|
        responses += SendgridClient.new(list).parsed_response
      end
      @csv = generate_email_csv(responses)
    end

  end
end