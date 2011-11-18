require "spec_helper"

describe LineItem do
  it {should validate_presence_of(:order_id) }
  it {should validate_presence_of(:variant_id) }
  it {should validate_presence_of(:quantity) }
end
