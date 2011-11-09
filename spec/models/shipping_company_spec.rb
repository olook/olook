# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ShippingCompany do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
