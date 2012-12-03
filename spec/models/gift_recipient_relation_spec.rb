# == Schema Information
#
# Table name: gift_recipient_relations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe GiftRecipientRelation do
  context "validation" do
    it { should validate_presence_of :name }
  end

  
end
