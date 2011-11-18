# -*- encoding : utf-8 -*-
require 'spec_helper'

describe FreightPrice do
  describe 'validations' do
    it { should validate_presence_of(:shipping_service) }
    it { should belong_to(:shipping_service) }

    describe 'zip_start' do
      it { should validate_presence_of(:zip_start) }
      it { should allow_value("05379020").for(:zip_start) }
      it { should_not allow_value("").for(:zip_start) }
      it { should_not allow_value("A").for(:zip_start) }
      it { should_not allow_value("053 79020").for(:zip_start) }
      it { should_not allow_value("05379-020").for(:zip_start) }
      it { should_not allow_value("100000000").for(:zip_start) }
    end

    describe 'zip_end' do
      it { should validate_presence_of(:zip_end) }
      it { should allow_value("05379020").for(:zip_end) }
      it { should_not allow_value("").for(:zip_end) }
      it { should_not allow_value("A").for(:zip_end) }
      it { should_not allow_value("053 79020").for(:zip_end) }
      it { should_not allow_value("05379-020").for(:zip_end) }
      it { should_not allow_value("100000000").for(:zip_end) }
    end

    describe 'weight_start' do
      it { should validate_presence_of(:weight_start) }
      it { should_not allow_value(-0.01).for(:weight_start) }
    end

    describe 'weight_end' do
      it { should validate_presence_of(:weight_end) }
      it { should_not allow_value(-0.01).for(:weight_end) }
    end

    describe 'delivery_time' do
      it { should validate_presence_of(:delivery_time) }
      it { should_not allow_value(1.1).for(:delivery_time) }
      it { should_not allow_value(-1).for(:delivery_time) }
    end

    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:cost) }
  end
end
