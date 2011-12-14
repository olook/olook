# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MarketingReport do
  let!(:user){ FactoryGirl.create :user }
  let!(:second_user){ FactoryGirl.create :user }

  context "#generate_csv" do
    it "contains a header with all the field names separated by comma in the first line" do
      subject.generate_csv.should match(/^id,first_name,last_name\n/)
    end

    it "contains user related data in the second line " do
      subject.generate_csv.should == "id,first_name,last_name\n" +
                                      "#{user.id},#{user.first_name},#{user.last_name}\n" +
                                      "#{second_user.id},#{second_user.first_name},#{second_user.last_name}\n"
    end
  end

end