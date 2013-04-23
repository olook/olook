# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ProductSearch do
  describe ".terms_for" do
    
    it "Redis receives zrevrange method " do
      Redis.any_instance.should_receive(:zrevrange)
      described_class.terms_for("Foo")
    end
  end
end
