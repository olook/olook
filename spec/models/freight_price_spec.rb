# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FreightPrice do
  describe 'validations' do
    it { should belong_to(:shipping_company) }

    it { should validate_presence_of(:zip_start) }
    it { should validate_presence_of(:zip_end) }
    it { should validate_presence_of(:weight_start) }
    it { should validate_presence_of(:weight_end) }
    it { should validate_presence_of(:delivery_time) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:cost) }
  end
end
