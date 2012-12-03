# == Schema Information
#
# Table name: contact_informations
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ContactInformation do
  it "should create a contact information" do
    ContactInformation.create!(:title => "Lorem ipsum dolor sit amet.", :email => "foo@bar.com")
  end
end
