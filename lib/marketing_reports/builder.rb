# -*- encoding : utf-8 -*-

module MarketingReports
  class Builder

    ACTIONS = [:userbase, :userbase_with_auth_token, :userbase_with_credits, :userbase_with_auth_token_and_credits]

    attr_accessor :csv

    def initialize(type = nil)
      @csv = ""
      self.send("generate_#{type}") if ACTIONS.include? type
    end

    def upload(filename, encoding = "ISO-8859-1")
      FileUploader.new(@csv).copy_to_ftp(filename, encoding)
    end

    def generate_userbase
      bounces = bounced_list
      @csv = CSV.generate do |csv|
        csv << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at invite_token first_name last_name facebook_token birthday has_purchases}
        User.where("gender != #{User::Gender[:male]} or gender is null").each do |u|
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
        csv << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at invite_token first_name last_name facebook_token birthday has_purchases current_credits}
        User.where("gender != #{User::Gender[:male]} or gender is null").each do |u|
          unless bounces.include?(u.email)
            csv << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at, u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, u.has_purchases?, u.current_credit ]
          end
        end
        emails_seed_list.each { |email| csv << [ nil, email, nil, nil, nil, nil, nil, 'seed list', nil, nil, nil, nil, nil ] }
      end
    end

    def generate_userbase_with_auth_token
      bounces = bounced_list
      @csv = CSV.generate do |csv|
        csv << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at invite_token first_name last_name facebook_token birthday has_purchases auth_token}
        User.where("gender != #{User::Gender[:male]} or gender is null").each do |u|
          unless bounces.include?(u.email)
            csv << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at, u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, u.has_purchases?, u.authentication_token ]
          end
        end
        emails_seed_list.each { |email| csv << [ nil, email, nil, nil, nil, nil, nil, 'seed list', nil, nil, nil, nil, nil ] }
      end
    end

    def generate_userbase_with_auth_token_and_credits
      bounces = bounced_list
      @csv = CSV.generate do |csv|
        csv << %w{ id email created_at sign_in_count current_sign_in_at last_sign_in_at invite_token first_name last_name facebook_token birthday has_purchases auth_token current_credit}
        User.where("gender != #{User::Gender[:male]} or gender is null").each do |u|
          unless bounces.include?(u.email)
            csv << [ u.id, u.email.chomp, u.created_at, u.sign_in_count, u.current_sign_in_at, u.last_sign_in_at, u.invite_token, u.first_name.chomp, u.last_name.chomp, u.facebook_token, u.birthday, u.has_purchases?, u.authentication_token, u.current_credit ]
          end
        end
        emails_seed_list.each { |email| csv << [ nil, email, nil, nil, nil, nil, nil, 'seed list', nil, nil, nil, nil, nil, nil ] }
      end
    end

    private

    def emails(data)
      data.map { |item| item["email"] }
    end

    def bounced_list
      responses = [:invalid_emails, :spam_reports, :unsubscribes, :blocks].inject([]) do |sum, service|
        sum += sendgrid_accounts_response(service)
      end
      responses += SendgridClient.new(:bounces, :type => "hard", :username => "olook2").parsed_response
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