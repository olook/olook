require 'spec_helper'

describe Freight do
  it { should belong_to(:address) }
  it { should belong_to(:order) }
  it { should belong_to(:shipping_service) }

  it { should validate_presence_of(:price) }
  it { should_not allow_value(-0.01).for(:price) }

  it { should validate_presence_of(:cost) }
  it { should_not allow_value(-0.01).for(:cost) }

  it { should validate_presence_of(:delivery_time) }
  it { should_not allow_value(1.1).for(:delivery_time) }
  it { should_not allow_value(-1).for(:delivery_time) }

  it { should validate_presence_of(:address_id) }
  it { should validate_presence_of(:shipping_service_id) }

  

end
