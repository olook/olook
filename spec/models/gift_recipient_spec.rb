# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GiftRecipient do
  context "validation" do
    it { should belong_to :user }
    it { should belong_to :gift_recipient_relation }
    
    it { should validate_presence_of :name }
    it { should validate_presence_of :shoe_size }
  end

end
