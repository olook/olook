require 'spec_helper'

describe RulesParameter do

  describe "validations" do

    it { should belong_to :promotion }
    it { should belong_to :promotion_rule }

  end

end
