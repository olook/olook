# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Picture do
  context "validation" do
    it { should validate_presence_of(:image) }
    it { should validate_presence_of(:product) }
    it { should belong_to(:product) }
  end
end
