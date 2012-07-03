require 'spec_helper'

describe Cart do
  it { should belong_to(:user) }
  it { should have_one(:order) }
  it { should have_many(:cart_items) }
  

end