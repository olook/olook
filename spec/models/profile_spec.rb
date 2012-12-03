# == Schema Information
#
# Table name: profiles
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  first_visit_banner :string(255)
#  alternative_name   :string(255)
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Profile do
  it "should create a profile" do
    Profile.create(:name => "Foo Profile")
  end
  
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :first_visit_banner }
    it { should have_and_belong_to_many(:products) }
  end
  
  describe "relationships" do
    it { should have_many :points }
    it { should have_many :weights }
  end
end
