# == Schema Information
#
# Table name: related_products
#
#  id           :integer          not null, primary key
#  product_a_id :integer          not null
#  product_b_id :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe RelatedProduct do
  describe "validation" do
    it { should validate_presence_of(:product_a_id) }
    it { should validate_presence_of(:product_b_id) }
  end
end
