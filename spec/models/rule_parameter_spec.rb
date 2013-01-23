require 'spec_helper'

describe RuleParameter do

  describe "validations" do

    it { should belong_to :promotion }
    it { should belong_to :promotion_rule }

  end

end
