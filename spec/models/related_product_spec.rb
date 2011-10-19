# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RelatedProduct do
  describe "validation" do
    it { should validate_presence_of(:product_a_id) }
    it { should validate_presence_of(:product_b_id) }
  end
end
