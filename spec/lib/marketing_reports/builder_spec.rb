# -*- encoding : utf-8 -*-

require 'spec_helper'

describe MarketingReports::Builder do
  let(:user_a) { FactoryGirl.create :user }
  let(:user_b) { FactoryGirl.create :user }
  let(:user_c) { FactoryGirl.create :user }
  let(:response) { double(:response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"teste@teste.com"} ]) }
  let(:services) do
    {
      :spam_reports   => double(:s_response, :parsed_response => [ {"reason"=>"Any", "email"=> "a@b.com"} ]),
      :unsubscribes   => double(:u_response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"g@h.com"} ]),
      :blocks         => double(:b_response, :parsed_response => [ {"reason"=>"Unknown", "email"=>"e@f.com"} ]),
      :invalid_emails => double(:i_response, :parsed_response => [ {"reason"=>"500", "email"=>"c@d.com"} ]),
    }
  end

  describe "#initialize" do
    context "when no type is passed" do
      it "sets csv to empty string" do
        subject.csv.should == ""
      end
    end
  end

  describe "#generate_invalid" do
    it "calls sendgrid invalid emails service on both sendgrids account" do
      MarketingReports::SendgridClient.should_receive(:new).with(:invalid_emails, :username => "olook").and_return(services[:invalid_emails])
      MarketingReports::SendgridClient.should_receive(:new).with(:invalid_emails, :username => "olook2").and_return(services[:invalid_emails])

      subject.generate_invalid
    end

    it "builds a csv file with invalid emails" do
      MarketingReports::SendgridClient.stub(:new).with(:invalid_emails, :username => "olook").and_return(services[:invalid_emails])
      MarketingReports::SendgridClient.stub(:new).with(:invalid_emails, :username => "olook2").and_return(services[:invalid_emails])

      subject.generate_invalid
      subject.csv.should == "c@d.com\nc@d.com\n"
    end
  end

  describe "#generate_optout" do
    let(:optout_services) { [:spam_reports, :unsubscribes, :blocks] }

    it "calls sendgrid spam_reports, unsubscribes and blocks services on olook and olook2 accounts" do
      optout_services.each do |name|
        MarketingReports::SendgridClient.should_receive(:new).with(name, :username => "olook").and_return(services[name])
        MarketingReports::SendgridClient.should_receive(:new).with(name, :username => "olook2").and_return(services[name])
      end

      subject.generate_optout
    end

    it "builds a csv file with emails from spam_reports, unsubscribes and blocks" do
      optout_services.each do |name|
        MarketingReports::SendgridClient.stub(:new).with(name, :username => "olook").and_return(services[name])
        MarketingReports::SendgridClient.stub(:new).with(name, :username => "olook2").and_return(services[name])

      end

      subject.generate_optout
      subject.csv.should == "a@b.com\na@b.com\ng@h.com\ng@h.com\ne@f.com\ne@f.com\n"
    end
  end

  describe "#userbase" do
    let(:csv_header) do
      "id,email,created_at,sign_in_count,current_sign_in_at,last_sign_in_at,invite_token,first_name,last_name,facebook_token,birthday,has_purchases\n"
    end

    before(:each) do
      services.each do |service, response|
        MarketingReports::SendgridClient.stub(:new).with(service, :username => "olook").and_return(response)
        MarketingReports::SendgridClient.stub(:new).with(service, :username => "olook2").and_return(response)
      end
    end

    it "builds a csv file containing all user data" do

      csv_body = [user_a, user_b, user_c].inject("") do |data, user|
        data += "#{user.id},#{user.email},#{user.created_at},#{user.sign_in_count},#{user.current_sign_in_at},#{user.last_sign_in_at},"
        data += "#{user.invite_token},#{user.first_name},#{user.last_name},#{user.facebook_token},#{user.birthday},#{user.has_purchases?}\n"
        data
      end

      subject.generate_userbase
      subject.csv.should match /^#{csv_header}#{csv_body}/
    end

    it "does not include a user which email was included in any bounced list (spam reports, unsubscribers, blocks or invalid)" do

      services = {
        :spam_reports   => double(:s_response, :parsed_response => [ {"reason" => "Any", "email" => user_a.email } ]),
        :unsubscribes   => double(:u_response, :parsed_response => [ {"reason" => "Unknown", "email" => user_b.email } ]),
        :blocks         => double(:b_response, :parsed_response => [ {"reason" => "Unknown", "email" => user_c.email } ]),
        :invalid_emails => double(:i_response, :parsed_response => [ {"reason" => "500", "email" => user_c.email } ])
      }

      services.each do |service, response|
        MarketingReports::SendgridClient.stub(:new).with(service, :username => "olook").and_return(response)
        MarketingReports::SendgridClient.stub(:new).with(service, :username => "olook2").and_return(response)
      end

      subject.generate_userbase
      subject.csv.should_not match user_a.email
      subject.csv.should_not match user_b.email
      subject.csv.should_not match user_c.email
    end

    it "includes return path seed email" do
      services.each do |service, response|
        MarketingReports::SendgridClient.stub(:new).with(service, :username => "olook").and_return(response)
        MarketingReports::SendgridClient.stub(:new).with(service, :username => "olook2").and_return(response)
      end
      subject.generate_userbase
      subject.csv.should match ",0000ref000.olook@000.monitor1.returnpath.net,,,,,,seed list,,,,\n"
    end

    it "includes delivery whatch seed email" do
      services.each do |service, response|
        MarketingReports::SendgridClient.stub(:new).with(service, :username => "olook").and_return(response)
        MarketingReports::SendgridClient.stub(:new).with(service, :username => "olook2").and_return(response)
      end
      subject.generate_userbase
      subject.csv.should match ",dwatch20@hotmail.com,,,,,,seed list,,,,\n"
    end
  end

  describe "#generete_userbase_orders" do

    let(:header) do
      "id,email,first_name,last_name,invite_bonus,used_bonus,order_id,order_total,order_state," +
      "order_date,variant_number,product_id,item_price,gift\n"
    end

    it "shows a csv header with user id, email, first and last name, bonus info and orders attributes" do
      subject.generate_userbase_orders
      subject.csv.should == header
    end

    context "and user has no orders and no bonus" do
      let!(:user) { FactoryGirl.create(:member) }
      it "lists user id, first and last_name, email for a user without orders" do
        user_data = "#{user.id},#{user.email},#{user.first_name},#{user.last_name},0.0,0.0,,,,,,,,\n"

        subject.generate_userbase_orders
        subject.csv.should match(/^#{header}#{user_data}/)
      end
    end

    context "and user has bonus credits" do
      let!(:user) { FactoryGirl.create(:member) }
      let!(:order) { FactoryGirl.create(:clean_order, :user => user, :credits => 10.00) }
      before do
        10.times do
          accepting_member = FactoryGirl.create(:member, :first_name => 'Accepting member')
          accepted_at = DateTime.civil(2011, 11, 10, 10, 0, 0)
          FactoryGirl.create(:sent_invite, :user => user, :invited_member => accepting_member, :accepted_at => accepted_at, :resubmitted => nil)
        end
      end

      it "lists user data and used bonus and total bonus" do
        user_data = "#{user.id},#{user.email},#{user.first_name},#{user.last_name},30.0,10.0,#{order.id},#{order.total},#{order.state},#{order.updated_at},,,,"
        subject.generate_userbase_orders
        subject.csv.should match(/^#{header}#{user_data}/)
      end
    end

    context "and user has an order with line items" do
      let!(:user) { FactoryGirl.create(:member) }
      let!(:order) { FactoryGirl.create(:order, :user => user) }
      let!(:line_item) { FactoryGirl.create(:line_item, :order => order) }

      it "lists a user data with order details (order total value, products ids, prices and variant numbers)" do
        user_order_data = "#{user.id},#{user.email},#{user.first_name},#{user.last_name},0.0,0.0," +
                          "#{order.id},359.8,#{order.state},#{order.updated_at},#{line_item.variant.number}," +
                          "#{line_item.variant.product_id},#{line_item.price},#{line_item.gift}\n"
        subject.generate_userbase_orders
        subject.csv.should match(/^#{header}#{user_order_data}/)
      end
    end

  end

  describe "#userbase_revenue" do
    let(:header) do
      "id,email,name,total_bonus,current_bonus,used_bonus,total_revenue,freight\n"
    end

    it "shows a csv header with user id, email, first and last name, bonus info and orders attributes" do
      subject.generate_userbase_revenue
      subject.csv.should == header
    end

    context "and user has credits and two orders with completed or authorized payments" do
      let!(:user) { FactoryGirl.create(:member) }
      let!(:order_a) { FactoryGirl.create(:clean_order, :user => user) }
      let!(:order_b) { FactoryGirl.create(:clean_order, :user => user) }

      before do
        10.times do
          accepting_member = FactoryGirl.create(:member, :first_name => 'Accepting member')
          accepted_at = DateTime.civil(2011, 11, 10, 10, 0, 0)
          FactoryGirl.create(:sent_invite, :user => user, :invited_member => accepting_member, :accepted_at => accepted_at, :resubmitted => nil)
        end
        order_a.payment.state = "authorized"
        order_b.payment.state = "completed"
        order_a.payment.save!
        order_b.payment.save!
      end

      it "lists user data with user bonus, freight and revenue per user" do
        total_revenue = order_a.total_with_freight + order_b.total_with_freight
        freight = order_a.freight_price + order_b.freight_price

        user_revenue_data = "#{user.id},#{user.email},#{user.name}," +
                            "#{user.invite_bonus + user.used_invite_bonus},#{user.invite_bonus},#{user.used_invite_bonus}," +
                            "#{total_revenue},#{freight}\n"

        subject.generate_userbase_revenue
        subject.csv.should == header + user_revenue_data
      end

    end
  end

  describe "#generate_paid_online_marketing" do
    let(:header) do
     "utm_source,utm_medium,utm_campaign,utm_content,total_registrations,total_orders,total_revenue_without_discount,total_revenue_with_discount\n"
    end

    it "shows a csv header with tracking attributes" do
      subject.generate_paid_online_marketing
      subject.csv.should == header
    end

    context "and there is tracking data from google (with gclid and placement)" do
      let!(:user_a) { FactoryGirl.create(:member) }
      let!(:user_b) { FactoryGirl.create(:member) }
      let!(:order_a) { FactoryGirl.create(:clean_order, :user => user_a) }
      let!(:order_b) { FactoryGirl.create(:clean_order, :user => user_b) }
      let!(:tracking_a) { FactoryGirl.create(:google_tracking, :user => user_a) }
      let!(:tracking_b) { FactoryGirl.create(:google_tracking, :user => user_b) }

      before do
        order_a.payment.billet_printed
        order_a.payment.authorized
        order_b.payment.billet_printed
        order_b.payment.authorized
        Order.any_instance.stub(:total).and_return(BigDecimal.new("100"))
        Order.any_instance.stub(:line_items_total).and_return(BigDecimal.new("50"))
      end

      let :tracking_data do
        "google,#{tracking_a.placement},,,2,2,100.0,200.0"
      end

      it "includes a row with google total registrations, total orders and revenue grouped by placement" do
        subject.generate_paid_online_marketing
        subject.csv.should match(/^#{header}#{tracking_data}/)
      end
    end

    context "and there is data from other sources (with utm params)" do
      let!(:user_c) { FactoryGirl.create(:member) }
      let!(:user_d) { FactoryGirl.create(:member) }
      let!(:order_c) { FactoryGirl.create(:clean_order, :user => user_c) }
      let!(:order_d) { FactoryGirl.create(:clean_order, :user => user_d) }
      let!(:tracking_c) { FactoryGirl.create(:tracking, :user => user_c) }
      let!(:tracking_d) { FactoryGirl.create(:tracking, :user => user_d) }

      before do
        order_c.payment.billet_printed
        order_c.payment.authorized
        order_d.payment.billet_printed
        order_d.payment.authorized
        Order.any_instance.stub(:total).and_return(BigDecimal.new("100"))
        Order.any_instance.stub(:line_items_total).and_return(BigDecimal.new("50"))
      end

      let :tracking_data do
        "#{tracking_c.utm_source},#{tracking_c.utm_medium},#{tracking_c.utm_campaign},#{tracking_c.utm_content},2,2,100.0,200.0"
      end

      it "includes a row with other sources total registrations, total orders and revenue grouped by utm params" do
        subject.generate_paid_online_marketing
        subject.csv.should match(/^#{header}#{tracking_data}/)
      end
    end
  end

  describe "#upload" do
    let(:csv) { "a,b,c" }
    let(:filename) { "filename.csv" }
    let(:encoding) { "utf-8" }
    let(:uploader) { double(:uploder) }

    before do
      subject.csv = csv
    end

    it "calls FileUploader passing the csv" do
      MarketingReports::FileUploader.should_receive(:new).with(csv).and_return(mock.as_null_object)
      subject.upload(filename)
    end

    it "calls copy_to_ftp on the file uploader with the passed filename and encoding" do
      MarketingReports::FileUploader.stub(:new).and_return(uploader)
      uploader.should_receive(:copy_to_ftp).with(filename,encoding)
      subject.upload(filename,encoding)
    end
  end

end
