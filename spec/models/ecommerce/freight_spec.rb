# == Schema Information
#
# Table name: freights
#
#  id                  :integer          not null, primary key
#  price               :decimal(8, 2)
#  cost                :decimal(8, 2)
#  delivery_time       :integer
#  order_id            :integer
#  address_id          :integer
#  shipping_service_id :integer          default(1)
#  tracking_code       :string(255)
#  country             :string(255)
#  city                :string(255)
#  state               :string(255)
#  complement          :string(255)
#  street              :string(255)
#  number              :string(255)
#  neighborhood        :string(255)
#  zip_code            :string(255)
#  telephone           :string(255)
#  mobile              :string(255)
#

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
