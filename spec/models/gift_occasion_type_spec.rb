# == Schema Information
#
# Table name: gift_occasion_types
#
#  id                         :integer          not null, primary key
#  name                       :string(255)      not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  day                        :integer
#  month                      :integer
#  gift_recipient_relation_id :integer
#

require 'spec_helper'

describe GiftOccasionType do
  context "validation" do
    it { should validate_presence_of :name }
  end

  
end
