# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserReport do
  describe ".generate_csv" do
    let(:first_user) { double(:user, FactoryGirl.attributes_for(:user, :cpf => "123456", :is_invited => false, :created_at => Date.today)) }
    let(:second_user) { double(:user, FactoryGirl.attributes_for(:user, :cpf => "654321", :is_invited => true, :created_at => Date.yesterday)) }
    let(:formatted_time) { "2011-31-12_00-00" }
    let(:file_name) { "users-#{formatted_time}.csv" }
    let(:file_path) { Rails.root.join("public", "admin", file_name) }

    before do
      User.stub_chain(:select, :find_each).and_yield(first_user).and_yield(second_user)
      Time.stub_chain(:now, :strftime).and_return(formatted_time)
    end

    after(:all) do
      File.delete file_path
    end

    it "should generate a CSV file in public/admin containing all Users in the database" do
      csv_string = <<-CSV.strip_heredoc
        First Name,Last Name,Email,Cpf,Is Invited,Created At
        #{first_user.first_name},#{first_user.last_name},#{first_user.email},#{first_user.cpf},#{first_user.is_invited},#{first_user.created_at}
        #{second_user.first_name},#{second_user.last_name},#{second_user.email},#{second_user.cpf},#{second_user.is_invited},#{second_user.created_at}
      CSV

      UserReport.generate_csv
      File.read(file_path).should == csv_string
    end

    it "should return the file name" do
      UserReport.generate_csv.should == file_name
    end
  end

  describe '.statistics' do
    let(:result_a) { double(:result, creation_date: Date.civil(2011, 11, 15), daily_total: 10 ) }
    let(:result_b) { double(:result, creation_date: Date.civil(2011, 11, 16), daily_total: 13 ) }
    let(:group_result) { [ result_a, result_b ] }

    let(:select_result) do
      select = double :select
      select.stub(:group).with("date(created_at)").and_return(group_result)
      select
    end

    it "should count the users created grouped by date" do
      User.stub(:select).with("date(created_at) as creation_date, count(id) as daily_total").and_return(select_result)

      described_class.statistics.should == group_result
    end
  end
end
