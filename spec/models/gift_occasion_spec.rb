# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GiftOccasion do

  context "validation" do
    it { should belong_to :user }

    it { should belong_to :gift_recipient }

    it { should belong_to :gift_occasion_type }

    describe "day" do
      it { should allow_value(7).for(:day) }
      it { should_not allow_value(0).for(:day) }
      it { should_not allow_value(32).for(:day) }
      it { should_not allow_value(" ").for(:day) }
    end

    describe "month" do
      it { should allow_value(7).for(:month) }
      it { should_not allow_value(0).for(:month) }
      it { should_not allow_value(13).for(:month) }
      it { should_not allow_value(" ").for(:month) }
    end
  end

end
