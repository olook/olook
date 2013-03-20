# -*- encoding : utf-8 -*-
module MarketingReports
  class Builder

    ACTIONS = [:userbase,
               :userbase_with_auth_token,
               :userbase_with_credits,
               :userbase_with_auth_token_and_credits,
               :in_cart_mail,
               :line_items_report,
               :campaign_emails]

    attr_accessor :csv

    def initialize(type = nil)
      @csv = ""
      self.send("generate_#{type}") if ACTIONS.include? type
    end

    def save_file(filename, adapt_encoding, info_ftp = nil)
      FileUploader.new(filename, @csv).save_local_file(adapt_encoding)
      FileUploader.copy_file(filename)
      FtpUploader.new(filename, info_ftp).upload_to_ftp if info_ftp && Rails.env.production?
    end

    def generate_userbase
      bounces = bounced_list
      @csv = CSV.generate do |csv|
        csv << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at invite_token first_name last_name facebook_token birthday has_purchases}
        User.where("gender != #{User::Gender[:male]} or gender is null").find_each do |u|
          unless bounces.include?(u.email)
            csv << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at, u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, u.has_purchases? ]
          end
        end
        emails_seed_list.each { |email| csv << [ nil, email, nil, nil, nil, nil, nil, 'seed list', nil, nil, nil, nil ] }
      end
    end

    def generate_userbase_with_credits
      bounces = bounced_list
      @csv = CSV.generate do |csv|
        csv << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at invite_token first_name last_name facebook_token birthday has_purchases credit_balance}
        User.select("(select sum(total_agora) from (
 select
  uc.user_id,
  (CASE ct.code
   WHEN 'invite' THEN
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0),0)  -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1),0)
   WHEN 'redeem' THEN
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0),0)  -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1),0)
   ELSE
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0 and c.activates_at <= date(now()) and c.expires_at >= date(now())),0)  -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1 and c.activates_at <= date(now()) and c.expires_at >= date(now())), 0)
   END
  ) total_agora
from user_credits uc
inner join credit_types ct on ct.id = uc.credit_type_id
group by uc.user_id, ct.code
) as tmp where tmp.user_id = users.id
) as credit_balance, (select count(orders.id) from orders where orders.user_id = users.id ) as total_purchases, users.*").where("gender != #{User::Gender[:male]} or gender is null").find_each(batch_size: 10000) do |u|
          unless bounces.include?(u.email)
            credit_balance = u.credit_balance.nil? ? BigDecimal.new("0.0") : u.credit_balance
            csv << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at, u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, (u.total_purchases > 0), credit_balance ]
          end
        end
        emails_seed_list.each { |email| csv << [ nil, email, nil, nil, nil, nil, nil, 'seed list', nil, nil, nil, nil, nil ] }
      end
    end

    def generate_userbase_with_auth_token
      bounces = bounced_list

      @csv = CSV.generate do |csv|
        csv << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at invite_token first_name last_name facebook_token birthday has_purchases auth_token}

        User.includes(:orders).where("gender != #{User::Gender[:male]} or gender is null").find_each(batch_size: 10000) do |u|
          purchases = u.orders.inject(0) do |sum, order|
            sum += 1
          end

          unless bounces.include?(u.email)
            csv << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at, u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, (purchases > 0), u.authentication_token ]
          end
        end

        emails_seed_list.each { |email|
          csv << [ nil, email, nil, nil, nil, nil, nil, 'seed list', nil, nil, nil, nil, nil ]
        }
      end
    end

    def generate_userbase_with_auth_token_and_credits
      bounces = bounced_list
      @csv = CSV.generate(col_sep: ";") do |csv|
        csv << %w{id email created_at invite_token first_name last_name facebook_token birthday has_purchases auth_token credit_balance half_user}
        User.select("(select sum(total_agora) from (
 select
  uc.user_id,
  (CASE ct.code
   WHEN 'invite' THEN
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0),0)  -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1),0)
   WHEN 'redeem' THEN
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0),0)  -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1),0)
   ELSE
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 0 and c.activates_at <= date(now()) and c.expires_at >= date(now())),0)  -
    IFNULL((select sum(c.value) from credits c where c.user_credit_id = uc.id and c.is_debit = 1 and c.activates_at <= date(now()) and c.expires_at >= date(now())), 0)
   END
  ) total_agora
from user_credits uc
inner join credit_types ct on ct.id = uc.credit_type_id
group by uc.user_id, ct.code
) as tmp where tmp.user_id = users.id
) as credit_balance, (select count(orders.id) from orders where orders.user_id = users.id ) as total_purchases, users.*").where("gender != #{User::Gender[:male]} or gender is null").find_each(batch_size: 50000) do |u|
          unless bounces.include?(u.email)
            credit_balance = u.credit_balance.nil? ? BigDecimal.new("0.0") : u.credit_balance
            credit_balance = credit_balance.to_s.gsub(".", ",")
            csv << [ u.id, u.email.chomp, u.created_at.strftime("%d-%m-%Y"), u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, (u.total_purchases > 0), u.authentication_token, credit_balance, u.half_user ]
          end
        end
        emails_seed_list.each { |email| csv << [ nil, email, nil, nil, 'seed list', nil, nil, nil, nil, nil, nil, nil ] }
      end
    end

    def generate_in_cart_mail
      conditions = UserNotifier.get_carts(
        Setting.in_cart_mail_how_long.to_i,
        Setting.in_cart_mail_range.to_i,
        [Setting.in_cart_mail_condition])

      file_lines = UserNotifier.send_in_cart( conditions.join(" AND ") )
      @csv = convert_to_iso(file_lines).join("\n")
    end

    def generate_line_items_report
      @csv = CSV.generate do |csv|
        csv << %w{state product_category product_detail email first_name }
        LineItem.joins(:order).where("orders.state = 'delivered'").find_each do |ln|
          csv << [ ln.order.state, ln.variant.product.category_humanize, ln.variant.product.details.first.description, ln.order.user.try(:email), ln.order.user.try(:first_name) ]
        end
      end
    end

    def generate_campaign_emails
      bounces = bounced_list
      @csv = CSV.generate do |csv|
        csv << [ 'email','created_at' ]
        CampaignEmail.uncoverted_users.find_each do |c|
          unless bounces.include?(c.email)
            csv << [ c.email, c.created_at.strftime("%d-%m-%Y") ]
          end
        end
      end
    end

    def bounced_list
      responses = [:invalid_emails, :spam_reports, :unsubscribes, :blocks].inject([]) do |sum, service|
        sum += sendgrid_accounts_response(service)
      end
      responses += SendgridClient.new(:bounces, :type => "hard", :username => "olook2").parsed_response
      emails(responses)
    end

    private

    def convert_to_iso(file_lines=[])
      file_lines.map do | line |
        begin
          line.force_encoding("ISO-8859-1").encode("ISO-8859-1")
        rescue
          Rails.logger.info("Conversion error #{line}")
          ""
        end
      end
    end

    def emails(data)
      data.map { |item| item["email"] }
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
